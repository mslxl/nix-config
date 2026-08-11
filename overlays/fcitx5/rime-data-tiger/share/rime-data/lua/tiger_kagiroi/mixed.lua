-- tiger_kagiroi/mixed.lua
-- Heuristic Tiger + Kagiroi mixed input.
-- Keep raw romaji in the composition and query both input methods on demand.

local viterbi = require("kagiroi/kagiroi_viterbi")
local romaji = require("tiger_kagiroi/romaji")

local M = {}
local kAccepted = 1
local kNoop = 2

local function collect(translation, limit, require_full, input_end)
  local result = {}
  if not translation then
    return result
  end
  local next_candidate, iterator = translation:iter()
  while #result < limit do
    local candidate = next_candidate(iterator)
    if not candidate then
      break
    end
    if not require_full or candidate._end == input_end then
      result[#result + 1] = candidate
    end
  end
  return result
end

local function append_unique(result, seen, candidate)
  local key = candidate and (candidate.text .. "\0" .. candidate._end) or ""
  if candidate and candidate.text ~= "" and not seen[key] then
    seen[key] = true
    result[#result + 1] = candidate
  end
end

local function tagged(candidate, kind, comment)
  return ShadowCandidate(
    candidate,
    kind,
    candidate.text,
    comment .. (candidate.comment or "")
  )
end

local function tiger_candidates(input, segment, env)
  if #input > 4 then
    return {}
  end
  return collect(
    env.tiger_translator:query(input, segment),
    env.tiger_candidate_count,
    true,
    segment._end
  )
end

local function raw_end_for_surface(parsed, surface)
  local kana_length = utf8.len(surface)
  return parsed.raw_for_kana[kana_length]
end

local function japanese_candidate(kind, segment, raw_end, text, comment)
  if not raw_end or raw_end <= 0 then return nil end
  local candidate = Candidate(kind, segment.start, segment.start + raw_end, text, comment or "")
  candidate.quality = 100
  return candidate
end

local function utf8_prefix(text, length)
  local next_offset = utf8.offset(text, length + 1)
  return next_offset and text:sub(1, next_offset - 1) or text
end

local function japanese_candidates(input, parsed, segment, env)
  if not parsed or parsed.hiragana == "" then return {} end

  local hiragana = parsed.hiragana
  local result, seen = {}, {}
  env.viterbi:clear()
  env.viterbi:analyze(hiragana)

  if parsed.complete then
    local sentences = env.viterbi:best_n()
    for _ = 1, env.japanese_candidate_count do
      local sentence = sentences()
      if not sentence then break end
      append_unique(result, seen, japanese_candidate(
        "tiger_kagiroi_japanese", segment, #input, sentence.candidate))
    end
  end

  if parsed.complete then
    local kanji_segment = Segment(0, #hiragana)
    kanji_segment.tags = Set({ "abc", "kagiroi" })
    local kanji = collect(
      env.kanji_translator:query(hiragana, kanji_segment),
      env.japanese_candidate_count, true, #hiragana)
    for _, candidate in ipairs(kanji) do
      if candidate.type ~= "sentence" then
        append_unique(result, seen, japanese_candidate(
          "tiger_kagiroi_japanese", segment, #input, candidate.text))
      end
    end
  end

  -- Analyze every safe romaji/kana boundary as a complete prefix. This makes
  -- useful selections such as gakkou|desu -> 学校|desu available even when
  -- Kagiroi's linguistic boundary iterator prefers a shorter prefix.
  local prefix_count = 0
  for kana_length = 2, parsed.kana_length do
    local raw_end = parsed.raw_for_kana[kana_length]
    if raw_end and raw_end < #input then
      local surface = utf8_prefix(hiragana, kana_length)
      env.viterbi:analyze(surface)
      local sentence = env.viterbi:best_n()()
      if sentence then
        local before = #result
        append_unique(result, seen, japanese_candidate(
          "tiger_kagiroi_japanese_prefix", segment, raw_end,
          sentence.candidate, "〔部分〕"))
        if #result > before then prefix_count = prefix_count + 1 end
        if prefix_count >= env.japanese_prefix_count then break end
      end
    end
  end

  -- Also retain Kagiroi's language-model-selected boundaries.
  env.viterbi:analyze(hiragana)
  local prefixes = env.viterbi:best_n_prefix()
  for phrase in prefixes do
    local raw_end = raw_end_for_surface(parsed, phrase.surface)
    if raw_end and raw_end < #input then
      local before = #result
      append_unique(result, seen, japanese_candidate(
        "tiger_kagiroi_japanese_prefix", segment, raw_end,
        phrase.candidate, "〔部分〕"))
      if #result > before then prefix_count = prefix_count + 1 end
      if prefix_count >= env.japanese_prefix_count then break end
    end
  end

  -- Kana is an unconditional Japanese output path, not a dictionary fallback.
  -- Keep it immediately after the best complete sentence so both conversion
  -- and direct kana input remain visible on the first page.
  local kana = hiragana
  local kana_type = "tiger_kagiroi_kana"
  local context = env.engine.context
  if context:get_option("katakana") then
    kana = env.hira2kata:convert(hiragana)
    kana_type = "tiger_kagiroi_katakana"
  elseif context:get_option("hw_katakana") then
    kana = env.hira2kata_halfwidth:convert(hiragana)
    kana_type = "tiger_kagiroi_katakana"
  end
  local kana_candidate = japanese_candidate(
    kana_type, segment, parsed.raw_consumed, kana,
    parsed.complete and "" or "〔部分〕")
  if kana_candidate then table.insert(result, math.min(2, #result + 1), kana_candidate) end
  return result
end

local function score(input, tiger, japanese, hiragana, mode, env)
  if mode == "tiger" then
    return 1000, -1000
  elseif mode == "japanese" then
    return -1000, 1000
  end

  local tiger_score = #tiger > 0 and 4 or -4
  local japanese_score = #japanese > 1 and 3 or -3
  local length = #input

  if length == 1 then
    tiger_score = tiger_score + 9
    japanese_score = japanese_score - 4
  elseif length <= 3 then
    -- Tiger short codes are intentional high-frequency abbreviations. When a
    -- complete Tiger candidate exists, it must precede Japanese conversion;
    -- users can still force the current segment to Japanese with Ctrl+Shift+J.
    tiger_score = tiger_score + 10
    japanese_score = japanese_score - 2
  elseif length == 4 then
    tiger_score = tiger_score + 1
    if #japanese >= 2 and japanese[1].text ~= hiragana then
      japanese_score = japanese_score + 3
    end
  else
    tiger_score = tiger_score - 8
    japanese_score = japanese_score + 7
  end

  if hiragana and not hiragana:match("[a-z]") then
    japanese_score = japanese_score + 3
  end
  if #japanese >= 2 and japanese[1].text ~= hiragana then
    japanese_score = japanese_score + 3
  end

  local previous = env.engine.context:get_property("tiger_kagiroi_previous")
  if previous == "tiger" then
    tiger_score = tiger_score + env.language_stickiness
  elseif previous == "japanese" then
    japanese_score = japanese_score + env.language_stickiness
  end

  return tiger_score, japanese_score
end

local function analyze(input, segment, env)
  local tiger = tiger_candidates(input, segment, env)
  local parsed = romaji.parse_detailed(input, true)
  local hiragana = parsed and parsed.hiragana or nil
  local japanese = japanese_candidates(input, parsed, segment, env)
  local mode = env.engine.context:get_property("tiger_kagiroi_force")
  local tiger_score, japanese_score = score(
    input, tiger, japanese, hiragana, mode, env)
  return tiger, japanese, hiragana, tiger_score, japanese_score
end

local function should_commit_tiger(input, next_character, context, env)
  if #input ~= 4 or context:get_property("tiger_kagiroi_force") == "japanese" then
    return false
  end
  local segment = Segment(0, #input)
  segment.tags = Set({ "abc", "tiger_kagiroi" })
  local tiger, japanese, _, tiger_score, japanese_score = analyze(input, segment, env)
  if #tiger == 0 then
    return false
  end
  local margin = tiger_score - japanese_score
  local japanese_word = #japanese > 1 and
    not japanese[1].type:match("^tiger_kagiroi_kana") and
    not japanese[1].type:match("^tiger_kagiroi_katakana")
  local may_continue_japanese = romaji.is_prefix(input .. next_character)
  return margin >= env.auto_commit_margin and not japanese_word and
    not may_continue_japanese
end

function M.processor_init(env)
  M.translator_init(env)
  env.commit_connection = env.engine.context.commit_notifier:connect(function(context)
    local candidate = context:get_selected_candidate()
    if candidate then
      if candidate.type:match("^tiger_kagiroi_japanese") or
          candidate.type:match("^tiger_kagiroi_kana") or
          candidate.type:match("^tiger_kagiroi_katakana") then
        context:set_property("tiger_kagiroi_previous", "japanese")
      elseif candidate.type:match("^tiger_kagiroi_tiger") then
        context:set_property("tiger_kagiroi_previous", "tiger")
      end
    end
    if not context:is_composing() then
      context:set_property("tiger_kagiroi_force", "")
    end
  end)
end

function M.processor_fini(env)
  if env.commit_connection then
    env.commit_connection:disconnect()
  end
  M.translator_fini(env)
end

function M.processor(key_event, env)
  if key_event:release() then
    return kNoop
  end
  local representation = key_event:repr()
  local mode = nil
  if representation:match("Control%+Shift%+[jJ]") or
      representation:match("Control%+[jJ]") and key_event:shift() then
    mode = "japanese"
  elseif representation:match("Control%+Shift%+[tT]") or
      representation:match("Control%+[tT]") and key_event:shift() then
    mode = "tiger"
  end
  local context = env.engine.context
  if mode then
    if not context:is_composing() then
      return kNoop
    end
    context:set_property("tiger_kagiroi_force", mode)
    context:refresh_non_confirmed_composition()
    return kAccepted
  end

  if key_event:ctrl() or key_event:alt() or key_event:super() or
      key_event.keycode < 0x61 or key_event.keycode > 0x7a then
    return kNoop
  end
  local input = context.input
  local next_character = string.char(key_event.keycode)
  if not should_commit_tiger(input, next_character, context, env) then
    return kNoop
  end

  local candidate = context:get_selected_candidate()
  if not candidate or not candidate.type:match("^tiger_kagiroi_tiger") then
    return kNoop
  end
  env.engine:commit_text(candidate.text)
  context:clear()
  context:set_property("tiger_kagiroi_previous", "tiger")
  context:push_input(next_character)
  return kAccepted
end

function M.translator_init(env)
  local config = env.engine.schema.config
  env.tiger_candidate_count = config:get_int("tiger_kagiroi/tiger_candidate_count") or 4
  env.japanese_candidate_count = config:get_int("tiger_kagiroi/japanese_candidate_count") or 4
  env.japanese_prefix_count = config:get_int("tiger_kagiroi/japanese_prefix_count") or 6
  env.language_stickiness = config:get_int("tiger_kagiroi/language_stickiness") or 1
  env.auto_commit_margin = config:get_int("tiger_kagiroi/auto_commit_margin") or 8
  env.tiger_schema = config:get_string("tiger_kagiroi/tiger_schema") or "tiger"

  env.tiger_translator = Component.Translator(
    env.engine, Schema(env.tiger_schema), "translator", "table_translator")
  env.kanji_translator = Component.Translator(
    env.engine, Schema("kagiroi_kanji"), "translator", "script_translator")
  env.hira2kata = Opencc("kagiroi_h2k.json")
  env.hira2kata_halfwidth = Opencc("kagiroi_h2kh.json")
  env.mem = Memory(env.engine, Schema("kagiroi"))
  env.matrix_lookup = ReverseLookup("kagiroi_matrix")
  env.viterbi = viterbi.new(env)
end

function M.translator_fini(env)
  env.viterbi = nil
  env.matrix_lookup = nil
  env.mem = nil
  env.hira2kata_halfwidth = nil
  env.hira2kata = nil
  env.kanji_translator = nil
  env.tiger_translator = nil
  collectgarbage()
end

function M.translator(input, segment, env)
  if segment:has_tag("easy_english") or
      input == "" or not input:match("^[a-z]+$") then
    return
  end

  local tiger, japanese, hiragana, tiger_score, japanese_score =
    analyze(input, segment, env)
  -- Keep incomplete romaji in the composition instead of letting speller
  -- clear it when neither dictionary has a complete candidate yet.
  if #tiger == 0 and #japanese == 0 then
    yield(Candidate("tiger_kagiroi_pending", segment.start, segment._end,
      input, "〔待〕"))
    return
  end

  local function yield_tiger()
    for _, candidate in ipairs(tiger) do
      yield(tagged(candidate, "tiger_kagiroi_tiger", ""))
    end
  end

  local function yield_japanese()
    for _, candidate in ipairs(japanese) do
      yield(tagged(candidate, candidate.type, ""))
    end
  end

  if japanese_score > tiger_score then
    yield_japanese()
    yield_tiger()
  else
    yield_tiger()
    yield_japanese()
  end
end

return {
  processor = {
    init = M.processor_init,
    fini = M.processor_fini,
    func = M.processor,
  },
  translator = {
    init = M.translator_init,
    fini = M.translator_fini,
    func = M.translator,
  },
}
