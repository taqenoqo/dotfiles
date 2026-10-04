function Table(tbl)
  return pandoc.Div(tbl, { class = "table-wrap", style = "--cols: " .. #tbl.colspecs })
end
