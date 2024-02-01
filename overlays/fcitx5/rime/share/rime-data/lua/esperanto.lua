local function curryRepX(src)
    return function(from)
        if (from == nil) then
            return src
        end
        return function(target)
            return string.gsub(string.gsub(src, from .. "x", target), from .. "X", target)
        end
    end
end

local function concatF(f1, args, f2)
    return f2(f1(args[1])(args[2]))
end

local function translator(input, seg)
    local alphabetTable = {
        { "c", "ĉ" },
        { "C", "Ĉ" },
        { "g", "ĝ" },
        { "G", "Ĝ" },
        { "h", "ĥ" },
        { "H", "Ĥ" },
        { "j", "ĵ" },
        { "J", "Ĵ" },
        { "s", "ŝ" },
        { "S", "Ŝ" },
        { "u", "ŭ" },
        { "U", "Ŭ" },
    }
    local fn = curryRepX(input)

    for _, i in ipairs(alphabetTable) do
        fn = concatF(fn, i, curryRepX)
    end

    local word = fn(nil)
    local cand = Candidate("word", seg.start, seg._end, word, "")
    --cand.quality = 1
    yield(cand)
end

local function append_blank_filter(input)
    local cands = {}

    for cand in input:iter() do
        if (not cand.comment:find("☯")) then
            table.insert(cands, cand)
        end
    end

    for i, cand in ipairs(cands) do
        yield(Candidate("word", cand.start, cand._end, cand.text .. " ", cand.comment))
    end
end

local function init(env)
    epoEnv = env
end

return { init = init, epo_translator = translator, epo_append_blank_filter = append_blank_filter }
