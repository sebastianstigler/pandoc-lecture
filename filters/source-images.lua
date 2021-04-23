if FORMAT ~= "latex" and FORMAT ~="beamer" then
  return
end

local function latex(str)
  return pandoc.RawInline('latex', str)
end

function figure_image (elem)
  local image = elem.content and elem.content[1]
  return (image.t == 'Image' and image.title == 'fig:')
    and image
    or nil
end

local lang = nil
local stringify = pandoc.utils.stringify

  function configure(meta)
    if meta['lang'] then
            lang = stringify(meta['lang'])
    end
  end


function Para (para)
  local img = figure_image(para)
  if not img or not img.caption or not img.attributes['source'] then
    return nil
  end

  local source = pandoc.Span(
    pandoc.read(img.attributes['source']).blocks[1].c
  )
  local source_identifier = "Quelle: "

  if lang ~= "de-DE" then
        source_identifier = "Source: "
  end
  local hypertarget = "{%%\n"
  local label = "\n"
  if img.identifier ~= img.title then
    hypertarget = string.format("\\hypertarget{%s}{%%\n",img.identifier)
    label = string.format("\n\\label{%s}",img.identifier)
  end
  local source_size = "\\small"
  if FORMAT == "beamer" then
    source_size = "\\tiny"
  end
  return pandoc.Para {
    latex(hypertarget .. "\\begin{figure}\n\\centering\n"),
    img,
    latex("\n\\vspace{-1em}\\caption*{\\indent"..source_size.."{\\color{gray}".. source_identifier),  source, latex("}}\\vspace{-1em}%"),
    latex("\n\\caption"), pandoc.Span(img.caption),
    latex(label .."\n\\end{figure}\n}\n")
  }
end
return {{Meta = configure}, {Para =Para}}
