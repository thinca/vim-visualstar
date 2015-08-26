" |star| for |Visual-mode|.
" Version: 0.5.0
" Author : thinca <thinca+vim@gmail.com>
" License: zlib License

if exists('g:loaded_visualstar')
  finish
endif
let g:loaded_visualstar = 1

let s:save_cpo = &cpo
set cpo&vim


function! s:search(type, g)
  let s:count = v:count1 . a:type
  let reg = '"'
  let [save_reg, save_type] = [getreg(reg), getregtype(reg)]
  normal! gv""y
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
endfunction

function! s:count()
  return s:count . "\<CR>"
endfunction

function! s:extra_commands()
  if exists('g:visualstar_extra_commands')
    return g:visualstar_extra_commands
  else
    return ''
  endif
endfunction


noremap <silent> <Plug>(visualstar-*) *
noremap <silent> <Plug>(visualstar-#) #
noremap <silent> <Plug>(visualstar-g*) g*
noremap <silent> <Plug>(visualstar-g#) g#

vnoremap <silent> <script> <Plug>(visualstar-*)
\        :<C-u>call <SID>search('/', 0)<CR><SID>(count)<SID>(extra_commands)
vnoremap <silent> <script> <Plug>(visualstar-#)
\        :<C-u>call <SID>search('?', 0)<CR><SID>(count)<SID>(extra_commands)
vnoremap <silent> <script> <Plug>(visualstar-g*)
\        :<C-u>call <SID>search('/', 1)<CR><SID>(count)<SID>(extra_commands)
vnoremap <silent> <script> <Plug>(visualstar-g#)
\        :<C-u>call <SID>search('?', 1)<CR><SID>(count)<SID>(extra_commands)

nnoremap <expr> <SID>(count) <SID>count()
nnoremap <expr> <SID>(extra_commands) <SID>extra_commands()


if !exists('g:visualstar_no_default_key_mappings') ||
\   !g:visualstar_no_default_key_mappings
  silent! xmap <unique> * <Plug>(visualstar-*)
  silent! xmap <unique> <kMultiply> <Plug>(visualstar-*)
  silent! xmap <unique> <S-LeftMouse> <Plug>(visualstar-*)
  silent! xmap <unique> # <Plug>(visualstar-#)
  silent! xmap <unique> g* <Plug>(visualstar-g*)
  silent! xmap <unique> g<kMultiply> <Plug>(visualstar-g*)
  silent! xmap <unique> g<S-LeftMouse> <Plug>(visualstar-g*)
  silent! xmap <unique> g# <Plug>(visualstar-g#)
endif


let &cpo = s:save_cpo
unlet s:save_cpo
