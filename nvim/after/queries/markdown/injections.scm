; extends

; MDX: highlight ESM import/export statements as TSX
((paragraph) @injection.content
  (#lua-match? @injection.content "^import%s.+%sfrom%s")
  (#set! injection.language "tsx")
  (#set! injection.include-children))

((paragraph) @injection.content
  (#lua-match? @injection.content "^export%s+[%w{]")
  (#set! injection.language "tsx")
  (#set! injection.include-children))
