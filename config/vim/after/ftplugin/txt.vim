" TXT
" Force txt to fit in 79 columns
setlocal formatoptions+=t
" Allow folding with marker
setlocal foldmethod=marker
setlocal commentstring=\ %s
" Make txt files more portable
if expand('%:e') == 'txt'
	silent call ConvertLineEndingsToUnix()
	silent call ConvertWindowsCharacters()
endif

