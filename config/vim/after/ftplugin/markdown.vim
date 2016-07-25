" MARKDOWN
" I write most of my markdown in english, and sometimes in french. I will
" disable English-only settings when I know I'm in a french directory
let thisFile = expand('%:p')
let isEnglish=1
if thisFile =~# 'roleplay'
  let isEnglish=0
endif

" Styling {{{
" Add headers with ,(1|2|3|4|5)
nnoremap <buffer> <leader>& I# <Esc>j
nnoremap <buffer> <leader>é I## <Esc>j
nnoremap <buffer> <leader>" I### <Esc>j
nnoremap <buffer> <leader>' I#### <Esc>j
nnoremap <buffer> <leader>( I##### <Esc>j
" `Code`
vnoremap <buffer> ` <Esc>mzg`>a`<Esc>g`<i`<Esc>`zl
" _Italic_
vnoremap <buffer> _ <Esc>mzg`>a_<Esc>g`<i_<Esc>`zl
" **Bold**
vnoremap <buffer> * <Esc>mzg`>a**<Esc>g`<i**<Esc>`zl
" }}}
" Linters {{{
if isEnglish ==# 1
  let b:syntastic_checkers = ['textlint']
endif
" }}}
" Folding {{{
function! MarkdownLevel()
  let currentLine = getline(v:lnum)
  let headerMarker = matchstr(currentLine, '^#\+')
  let headerLevel = len(headerMarker)

  if headerLevel > 0
    return '>'.headerLevel
  endif

  return '='
endfunction
setlocal foldexpr=MarkdownLevel()  
setlocal foldmethod=expr  
" }}}
" Running the file in the browser {{{
nnoremap <silent> <buffer> <F5> :call MarkdownConvertAndRun()<CR>
function! MarkdownConvertAndRun()
  let thisFile = shellescape(expand('%:p'))
  let htmlFile = '/tmp/vim-generated-markdown.html'
  " Create the html file
  silent execute '!markdown ' . thisFile . ' > ' . shellescape(htmlFile)
  " Run it
  call OpenUrlInBrowser(htmlFile)
endfunction
" }}}
" Wrapping {{{
" Auto-wrap text
setlocal formatoptions+=t
" }}}
" Keybindings {{{
" Add current copy-paste buffer to link on word
nnoremap <buffer> ]] "zciw[<Esc>"zpi<Right>](<Esc>"*pi<Right>)<Esc>mzvipgq`z
vnoremap <buffer> ]] "zc[]()<Esc>hhh"zpll"*p
" }}}
" Cleaning the file {{{
inoremap <silent> <buffer> <F4> <Esc>:call MarkdownBeautify()<CR>
nnoremap <silent> <buffer> <F4> :call MarkdownBeautify()<CR>
function! MarkdownBeautify() 
  " Remove bad chars after copy-paste
  silent! %s/’/'/e
  silent! %s/‘/'/e
  silent! %s/“/"/e
  silent! %s/”/"/e

  " Textlint
  let thisFile = shellescape(expand('%:p'))
  let tmpFile = '/tmp/vim-textlint-markdown.md'
  " textlint --fix changes the file in place. So we copy the content into a tmp
  " file, fix it, and then output the fixed file
  let command = '%!> ' . tmpFile .
        \' && textlint --fix ' . tmpFile . ' &>/dev/null' .
        \' && cat ' . tmpFile
  execute command

  " Remove trailing spaces
	call RemoveTrailingSpaces()

  " Convert links into references
  silent! %! formd -r



  " " Fix common typos/errors
  " silent! %s/\<requete/requête/e
  " silent! %s/\<plutot\>/plutôt/e
  " silent! %s/\<fenetre/fenêtre/e
  " silent! %s/\<interessant/intéressant/e
  " silent! %s/\<accelerer\>/accélérer/e
  " silent! %s/\<interet/intérêt/e
  " silent! %s/\<entete/entête/e
  " silent! %s/\<tres\>/très/e
  " silent! %s/\<trés\>/très/e
  " silent! %s/\<etre\>/être/e
  " silent! %s/\<coute\>/coûte/e

endfunction
" }}}
" Spellchecking {{{
setlocal spelllang=en
if isEnglish ==# 0
  setlocal spelllang=fr
endif
" Change language and/or toggle
nnoremap <buffer> se :setlocal spelllang=en<CR>
nnoremap <buffer> sf :setlocal spelllang=fr<CR>
nnoremap <buffer> <F6> :setlocal spell!<CR>
inoremap <buffer> <F6> <Esc>:setlocal spell!<CR>i
" Next/Previous error
nnoremap <buffer> sj ]s
nnoremap <buffer> sk [s
" Add/Remove from dictionary
nnoremap <buffer> sa zg]s
nnoremap <buffer> sr zug
" Suggest correction
nnoremap <buffer> ss viw<Esc>i<C-X>s<C-N><C-P>
" }}}
" Map drawing {{{
nnoremap <buffer> <Leader>wh r━
vnoremap <buffer> <Leader>wh r━
nnoremap <buffer> <Leader>wv r┃
vnoremap <buffer> <Leader>wv r┃
nnoremap <buffer> <Leader>wtl r┏
nnoremap <buffer> <Leader>wtr r┓
nnoremap <buffer> <Leader>wbr r┛
nnoremap <buffer> <Leader>wbl r┗
nnoremap <buffer> <Leader>wxx r╋
nnoremap <buffer> <Leader>wxt r┻
nnoremap <buffer> <Leader>wxr r┣
nnoremap <buffer> <Leader>wxb r┳
nnoremap <buffer> <Leader>wxl r┫
" }}}
