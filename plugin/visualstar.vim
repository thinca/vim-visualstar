" |star| for |Visual-mode|.
" Version: 0.1.0
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

if exists('g:loaded_visualstar')
  finish
endif
let g:loaded_visualstar = 1

let s:save_cpo = &cpo
set cpo&vim


function! s:search(type)
  let reg = '"'
  let [save_reg, save_type] = [getreg(reg), getregtype(reg)]
  normal! gvy
  let text = @"
  call setreg(reg, save_reg, save_type)

  let @/ = '\V' . substitute(escape(text, '\' . a:type), "\n", '\\n', 'g')
  call histadd('/', @/)
endfunction



noremap <silent> <Plug>(visualstar)   *
noremap <silent> <Plug>(visualstar-#) #

vnoremap <silent> <Plug>(visualstar)   :<C-u>call <SID>search('/')<CR>/<CR>
vnoremap <silent> <Plug>(visualstar-#) :<C-u>call <SID>search('?')<CR>?<CR>



if !exists('g:visualstar_no_default_key_mappings') ||
\   !g:visualstar_no_default_key_mappings
  silent! vmap <unique> * <Plug>(visualstar)
  silent! vmap <unique> # <Plug>(visualstar-#)
endif


let &cpo = s:save_cpo
unlet s:save_cpo
