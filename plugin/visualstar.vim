" |star| for |Visual-mode|.
" Version: 0.2.1
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

if exists('g:loaded_visualstar')
  finish
endif
let g:loaded_visualstar = 1

let s:save_cpo = &cpo
set cpo&vim


function! s:search(type, g)
  let reg = '"'
  let [save_reg, save_type] = [getreg(reg), getregtype(reg)]
  normal! gvy
  let text = @"
  call setreg(reg, save_reg, save_type)

  let [pre, post] = ['', '']
  if !a:g
    let head = matchstr(text, '^.')
    let is_head_multibyte = 1 < len(head)
    let [l, col] = getpos("'<")[1 : 2]
    let line = getline(l)
    let before = line[: col - 2]
    let outer = matchstr(before, '.$')
    if text =~# '^\k' && ((!empty(outer) && len(outer) != len(head)) ||
    \   (!is_head_multibyte && (col == 1 || before !~# '\k$')))
      let pre = '\<'
    endif

    let tail = matchstr(text, '.$')
    let is_tail_multibyte = 1 < len(tail)
    let [l, col] = getpos("'>")[1 : 2]
    let col += len(tail) - 1
    let line = getline(l)
    let after = line[col :]
    let outer = matchstr(after, '^.')
    if text =~# '\k$' && ((!empty(outer) && len(outer) != len(tail)) ||
    \   (!is_tail_multibyte && (col == len(line) || after !~# '^\k')))
      let post = '\>'
    endif
  endif

  let text = substitute(escape(text, '\' . a:type), "\n", '\\n', 'g')

  let @/ = '\V' . pre . text . post
  call histadd('/', @/)

  let s:count = v:count1 . a:type
endfunction

function! s:count()
  return s:count . "\<CR>"
endfunction



noremap <silent> <Plug>(visualstar-*) *
noremap <silent> <Plug>(visualstar-#) #
noremap <silent> <Plug>(visualstar-g*) g*
noremap <silent> <Plug>(visualstar-g#) g#

vnoremap <silent> <script> <Plug>(visualstar-*)
\        :<C-u>call <SID>search('/', 0)<CR><SID>(count)
vnoremap <silent> <script> <Plug>(visualstar-#)
\        :<C-u>call <SID>search('?', 0)<CR><SID>(count)
vnoremap <silent> <script> <Plug>(visualstar-g*)
\        :<C-u>call <SID>search('/', 1)<CR><SID>(count)
vnoremap <silent> <script> <Plug>(visualstar-g#)
\        :<C-u>call <SID>search('?', 1)<CR><SID>(count)

nnoremap <expr> <SID>(count) <SID>count()


if !exists('g:visualstar_no_default_key_mappings') ||
\   !g:visualstar_no_default_key_mappings
  silent! vmap <unique> * <Plug>(visualstar-*)
  silent! vmap <unique> # <Plug>(visualstar-#)
  silent! vmap <unique> g* <Plug>(visualstar-g*)
  silent! vmap <unique> g# <Plug>(visualstar-g#)
endif


let &cpo = s:save_cpo
unlet s:save_cpo
