" CSS
" Misc {{{
" Remove - and _ from delimiters
setlocal iskeyword=@,48-57,192-255
" }}}
" Indentation rules {{{
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal equalprg=css-beautify\ -s\ 2\ -f\ -
" }}}
" Folding {{{
setlocal foldmethod=syntax
" }}}
" Custom bindings {{{
" is stands for [i]n [s]elector, #header li
noremap <buffer> is :<c-u>execute "normal! ?{\r:nohlsearch\r^vt{h"<CR>
nunmap  <buffer> is
" ip stands for [i]n [p]roperty, background-color
noremap <buffer> ip :<C-U>normal! ^vt:<CR>
nunmap  <buffer> ip
" iv stands for [i]n [v]alue, 3px solid red
noremap <buffer> iv :<C-U>normal! ^f:lvt;<CR>
nunmap  <buffer> iv
" ir stands for [i]n [r]ules,  { ... }
noremap <buffer> ir iB
nunmap  <buffer> ir
" ar stands for [a]round [r]ules, selector { ... }
noremap <buffer> ar :<C-U>execute "normal! ?{\rV/}\r"<CR>
nunmap  <buffer> ar
" }}}
" Linters {{{
let b:repo_root = GetRepoRoot()
let b:syntastic_checkers = []
" Use only linters defined in the repo
if filereadable(b:repo_root . '/.stylelintrc')
  let b:syntastic_css_stylelint_exec = StrTrim(system('npm-which stylelint'))
  let b:syntastic_checkers = b:syntastic_checkers + ['stylelint']
endif
if filereadable(b:repo_root . '/.recessrc')
  let b:syntastic_css_eslint_exec = StrTrim(system('npm-which recess'))
  let b:syntastic_checkers = b:syntastic_checkers + ['recess']
endif
if filereadable(b:repo_root . '/.csslintrc')
  let b:syntastic_css_eslint_exec = StrTrim(system('npm-which csslint'))
  let b:syntastic_checkers = b:syntastic_checkers + ['csslint']
endif
" Default to system-wide stylelint if nothing configured
if len(b:syntastic_checkers) == 0
  let b:syntastic_css_stylelint_exec = 'stylelint'
  let b:syntastic_checkers = b:syntastic_checkers + ['stylelint']
endif
"}}}
" Cleaning the file {{{
nnoremap <silent> <buffer> <F4> :call CssBeautify()<CR>
function! CssBeautify() 
	execute '%!css-beautify -s 2 -f -'
	call RemoveTrailingSpaces()
endfunction
" }}}
