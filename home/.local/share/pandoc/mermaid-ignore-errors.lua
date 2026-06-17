local function skip_invalid_mermaid()
  io.stderr:write("[mermaid-ignore-errors] skipped invalid mermaid block\n")
  return {}
end

local function render_mermaid_svg(block)
  local source_doc = pandoc.Pandoc({ block }, pandoc.Meta({}))
  local source_json = pandoc.write(source_doc, "json")
  local rendered_ok, rendered_json = pcall(function()
    return pandoc.pipe(
      "env",
      { "MERMAID_FILTER_FORMAT=svg", "mermaid-filter" },
      source_json
    )
  end)

  if not rendered_ok then
    return skip_invalid_mermaid()
  end

  local parsed_ok, rendered_doc = pcall(function()
    return pandoc.read(rendered_json, "json")
  end)

  if not parsed_ok then
    return skip_invalid_mermaid()
  end

  return rendered_doc.blocks
end

function CodeBlock(block)
  if not block.classes:includes("mermaid") then
    return nil
  end

  return render_mermaid_svg(block)
end
