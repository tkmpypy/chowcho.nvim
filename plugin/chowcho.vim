if exists('g:loaded_chowcho')
  finish
endif

let g:loaded_chowcho = 1

hi! ChowchoFloat guifg=#FF0000 guibg=NONE guisp=NONE gui=NONE cterm=bold

" TODO(tkmpypy)
let g:chowcho_exclude_filetypes = []

autocmd CursorMoved,CursorMovedI * call luaeval('require("chowcho").on_cursor_moved()')

command! -nargs=0 -bang Chowcho call luaeval('require("chowcho").run()')
