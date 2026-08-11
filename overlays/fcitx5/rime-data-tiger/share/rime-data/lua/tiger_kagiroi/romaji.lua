-- Deterministic Hepburn/Kunrei romaji parser for mixed input.
-- Besides kana, it records which raw-romaji offset produced each kana
-- boundary. Rime candidates can therefore consume a Japanese prefix while
-- leaving the unselected romaji suffix in the composition.
local M = {}

local kana = {
  a="あ", i="い", u="う", e="え", o="お",
  ka="か", ki="き", ku="く", ke="け", ko="こ",
  ga="が", gi="ぎ", gu="ぐ", ge="げ", go="ご",
  sa="さ", si="し", shi="し", su="す", se="せ", so="そ",
  za="ざ", zi="じ", ji="じ", zu="ず", ze="ぜ", zo="ぞ",
  ta="た", ti="ち", chi="ち", tu="つ", tsu="つ", te="て", to="と",
  da="だ", di="ぢ", du="づ", de="で", ["do"]="ど",
  na="な", ni="に", nu="ぬ", ne="ね", no="の",
  ha="は", hi="ひ", hu="ふ", fu="ふ", he="へ", ho="ほ",
  ba="ば", bi="び", bu="ぶ", be="べ", bo="ぼ",
  pa="ぱ", pi="ぴ", pu="ぷ", pe="ぺ", po="ぽ",
  ma="ま", mi="み", mu="む", me="め", mo="も",
  ya="や", yu="ゆ", yo="よ",
  ra="ら", ri="り", ru="る", re="れ", ro="ろ",
  wa="わ", wi="うぃ", we="うぇ", wo="を",
  kya="きゃ", kyu="きゅ", kyo="きょ", kye="きぇ",
  gya="ぎゃ", gyu="ぎゅ", gyo="ぎょ", gye="ぎぇ",
  sya="しゃ", syu="しゅ", syo="しょ", sha="しゃ", shu="しゅ", sho="しょ", she="しぇ",
  zya="じゃ", zyu="じゅ", zyo="じょ", jya="じゃ", jyu="じゅ", jyo="じょ",
  ja="じゃ", ju="じゅ", jo="じょ", je="じぇ",
  tya="ちゃ", tyu="ちゅ", tyo="ちょ", cha="ちゃ", chu="ちゅ", cho="ちょ", che="ちぇ",
  dya="ぢゃ", dyu="ぢゅ", dyo="ぢょ",
  nya="にゃ", nyu="にゅ", nyo="にょ", nye="にぇ",
  hya="ひゃ", hyu="ひゅ", hyo="ひょ", hye="ひぇ",
  bya="びゃ", byu="びゅ", byo="びょ", bye="びぇ",
  pya="ぴゃ", pyu="ぴゅ", pyo="ぴょ", pye="ぴぇ",
  mya="みゃ", myu="みゅ", myo="みょ", mye="みぇ",
  rya="りゃ", ryu="りゅ", ryo="りょ", rye="りぇ",
  fa="ふぁ", fi="ふぃ", fe="ふぇ", fo="ふぉ", fya="ふゃ", fyu="ふゅ", fyo="ふょ",
  va="ゔぁ", vi="ゔぃ", vu="ゔ", ve="ゔぇ", vo="ゔぉ",
  tsa="つぁ", tsi="つぃ", tse="つぇ", tso="つぉ",
  tha="てゃ", thi="てぃ", thu="てゅ", the="てぇ", tho="てょ",
  dha="でゃ", dhi="でぃ", dhu="でゅ", dhe="でぇ", dho="でょ",
  kwa="くぁ", kwi="くぃ", kwe="くぇ", kwo="くぉ",
  gwa="ぐぁ", gwi="ぐぃ", gwe="ぐぇ", gwo="ぐぉ",
  qa="くぁ", qi="くぃ", qe="くぇ", qo="くぉ",
  ye="いぇ", wyi="ゐ", wye="ゑ",
  la="ぁ", li="ぃ", lu="ぅ", le="ぇ", lo="ぉ",
  xa="ぁ", xi="ぃ", xu="ぅ", xe="ぇ", xo="ぉ",
  lya="ゃ", lyu="ゅ", lyo="ょ", xya="ゃ", xyu="ゅ", xyo="ょ",
  ltu="っ", ltsu="っ", xtu="っ", xtsu="っ",
}

local consonants = "bcdfghjklmpqrstvwxyz"
local vowels_or_y = "aiueoy"

local function has_completion(tail)
  if tail == "" then return true end
  if tail == "n" then return true end
  for code, _ in pairs(kana) do
    if code:sub(1, #tail) == tail then
      return true
    end
  end
  return #tail == 1 and consonants:find(tail, 1, true) ~= nil
end

local function add_token(state, text, raw_end)
  state.parts[#state.parts + 1] = text
  local old_length = state.kana_length
  state.kana_length = old_length + utf8.len(text)
  -- A multi-kana token such as kya -> きゃ has no safe raw boundary after
  -- its first kana. Only its final kana consumes the complete token.
  state.raw_for_kana[state.kana_length] = raw_end
end

function M.parse_detailed(input, allow_partial)
  if not input or input == "" or not input:match("^[a-z]+$") then
    return nil
  end
  local state = {
    parts = {}, raw_for_kana = {}, kana_length = 0,
    raw_consumed = 0, complete = false, pending = "",
  }
  local position = 1
  while position <= #input do
    local rest = input:sub(position)
    local first = rest:sub(1, 1)
    local second = rest:sub(2, 2)

    if #rest >= 2 and first == second and
        consonants:find(first, 1, true) and first ~= "n" then
      add_token(state, "っ", position)
      position = position + 1
    elseif first == "n" then
      if second == "n" then
        add_token(state, "ん", position)
        position = position + 1
      elseif second == "" or not vowels_or_y:find(second, 1, true) then
        add_token(state, "ん", position)
        position = position + 1
      else
        local matched = false
        for length = math.min(4, #rest), 1, -1 do
          local code = rest:sub(1, length)
          if kana[code] then
            add_token(state, kana[code], position + length - 1)
            position = position + length
            matched = true
            break
          end
        end
        if not matched then break end
      end
    else
      local matched = false
      for length = math.min(4, #rest), 1, -1 do
        local code = rest:sub(1, length)
        if kana[code] then
          add_token(state, kana[code], position + length - 1)
          position = position + length
          matched = true
          break
        end
      end
      if not matched then break end
    end
  end

  state.raw_consumed = position - 1
  state.pending = input:sub(position)
  state.complete = state.pending == ""
  state.hiragana = table.concat(state.parts)
  if state.hiragana == "" then
    return nil
  end
  if not state.complete and (not allow_partial or not has_completion(state.pending)) then
    return nil
  end
  return state
end

function M.parse(input)
  local result = M.parse_detailed(input, false)
  return result and result.hiragana or nil
end

function M.is_prefix(input)
  if not input or input == "" or not input:match("^[a-z]+$") then
    return false
  end
  if M.parse_detailed(input, true) then
    return true
  end
  for code, _ in pairs(kana) do
    if M.parse(input .. code) then
      return true
    end
  end
  return false
end

return M
