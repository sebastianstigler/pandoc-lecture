-- Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
-- Copyright: (c) 2018 Carsten Gips
-- License: MIT


-- collect all questions
questions = {}
bquestions = {}


-- generate table of all question headers
function collectQuestionHeaders(el)
    local p = tonumber(el.attributes["punkte"]) or 0
    local bp = tonumber(el.attributes["bonuspunkte"]) or 0
    local c = el.content

    -- collect only questions with points ...
    if p > 0 then
        table.insert(c, pandoc.Space())
        table.insert(c, pandoc.Str("(" .. p .. "P)"))
        table.insert(questions, pandoc.MetaInlines(c))
    end
    if bp > 0 then
        table.insert(c, pandoc.Space())
        table.insert(c, pandoc.Str("(" .. bp .. "P)"))
        table.insert(questions, pandoc.MetaInlines(c))
    end
end


-- set question metadata (if requested)
function setQuestionMetadata(meta)
    meta["questions"] = pandoc.MetaList(questions)
    meta["bquestions"] = pandoc.MetaList(bquestions)

    return meta
end


return { { Header = collectQuestionHeaders }, { Meta = setQuestionMetadata } }

