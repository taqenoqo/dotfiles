function CodeBlock(block)
  if block.classes:includes("mermaid") then
    return pandoc.Div(pandoc.Plain(pandoc.Str(block.text)), { class = "mermaid" })
  end
end
