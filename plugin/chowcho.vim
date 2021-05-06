if exists('g:loaded_chowcho')
  finish
endif

let g:loaded_chowcho = 1

command! -nargs=0 -bang Chowcho call luaeval('require("chowcho").run()')
