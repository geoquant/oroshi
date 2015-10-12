" JAVASCRIPT
" Misc {{{
" Remove - and _ from delimiters
setlocal iskeyword=@,48-57,192-255
" Indentation rules
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal equalprg=js-beautify\ -f\ -
" }}}
" TernJS {{{
nnoremap <buffer> tr :TernRename<CR>
nnoremap <buffer> td :TernDef<CR>
nnoremap <buffer> tt :TernType<CR>
nnoremap <buffer> tg :TernRefs<CR>
" }}}
" Folding {{{
setlocal foldmethod=syntax
setlocal foldlevelstart=99
setlocal foldtext=JavascriptFoldText()
function! JavascriptFoldText()
  let output = getline(v:foldstart)
  let lines = v:foldend - v:foldstart
  let output = substitute(output, '{$', '{...' . lines . '}', '')
  let output = substitute(output, '[$', '[...' . lines . ']', '')
  return output
endfunction

function! JavascriptSort()
  " We need to be able to sort multi-nested objects and arrays. The naive :sort
  " implementation won't work. We'll then use a specific macro that will do the
  " following.
  " - Select all the content
  " - Yank it and paste it in a new buffer
  " - Go to the first line and search for {\n
  " - Select all that is inside the {} with va}
  " - Get up one line
  " - Replace all new lines with a specific marker in this selection
  " - Go down one line
  " - Restart until we found all {
  " - Go back up, and start again with []
  " - Select everything and sort it
  " - Replace the original selection with the new one
  "
  " Another way to do it, instead of using a new buffer would be to add specific
  " markers to the end of the selection to be able to follow the last line even
  " when changin
  let current_position = getpos('.')
  let marker_string = '__MARKER_STRING__'

  " Put selection content in z register
  normal! gv"zy

  let content = @z
  " Join lines using custom string
  let content = substitute(content, '{\n', '{' . marker_string, 'g')
  let content = substitute(content, '\n}', marker_string . '}', 'g')
  let content = substitute(content, '[\n', ']' . marker_string, 'g')
  let content = substitute(content, '\n]', marker_string . ']', 'g')
  echom "==="
  echom content

  let split_content = sort(split(content, '\n'))
  " echom len(split_content)
  echom "==="



  " Sort the resulting content


  " Reselect and paste content of z register
  normal! gvd"zP
  call setpos('.', current_position)
endfunction

vnoremap S :<C-U>call JavascriptSort()<CR>
" <C-R>=JavascriptSort()<CR>

" }}}
" Rainbow parentheses {{{
if exists(':RainbowParenthesesToggle')
  augroup rainbow_parentheses_javascript
    au!
    au Syntax <buffer> syntax clear jsFuncBlock
    au Syntax <buffer> RainbowParenthesesLoadRound
    au Syntax <buffer> RainbowParenthesesLoadSquare
    au Syntax <buffer> RainbowParenthesesLoadBraces
  augroup END
endif
" }}}
" Linters {{{
let b:repo_root = GetRepoRoot()
let b:syntastic_checkers = []
" Use only linters defined in the repo
if filereadable(b:repo_root . '/.eslintrc')
  let b:syntastic_javascript_eslint_exec = StrTrim(system('npm-which eslint'))
  let b:syntastic_checkers = b:syntastic_checkers + ['eslint']
endif
if filereadable(b:repo_root . '/.jshintrc')
  let b:syntastic_javascript_eslint_exec = StrTrim(system('npm-which jshint'))
  let b:syntastic_checkers = b:syntastic_checkers + ['jshint']
endif
if filereadable(b:repo_root . '/.jscsrc')
  let b:syntastic_javascript_eslint_exec = StrTrim(system('npm-which jscs'))
  let b:syntastic_checkers = b:syntastic_checkers + ['jscs']
endif
" Default to system-wide eslint if nothing configured
if len(b:syntastic_checkers) == 0
  let b:syntastic_checkers = b:syntastic_checkers + ['eslint']
endif
"}}}
" Cleaning the file {{{
inoremap <silent> <buffer> <F4> <Esc>:call JavascriptBeautify()<CR>
nnoremap <silent> <buffer> <F4> :call JavascriptBeautify()<CR>
function! JavascriptBeautify() 
	call RemoveTrailingSpaces()
endfunction
" }}}
" Keybindings {{{
" $ù is easy to type on my keyboard. Use it for debug calls
inoremap <buffer> $ù console.info(
" }}}
" ES6 {{{
" Enable JSX syntax highlight in javascript files
let g:jsx_ext_required = 0
" }}}
