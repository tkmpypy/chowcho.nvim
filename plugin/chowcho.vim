if exists('g:loaded_chowcho')
  finish
endif

let g:loaded_chowcho = 1

autocmd CursorMoved,CursorMovedI * call luaeval('require("chowcho").on_cursor_moved()')

command! -nargs=0 -bang Chowcho call luaeval('require("chowcho").run()')
