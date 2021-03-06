" GIT

" KEYBINDINGS
" Those are keyboard hotkeys that I already use in my terminal for the most
" common git tasks. They are replicated inside of vim for a better workflow
" integration.

" [f]iles {{{
" Add current file to index
nnoremap <silent> vfa :Gwrite<CR>:call GitUpdateStatusLine()<CR>
" Remove current file from index
nnoremap <silent> vfu :Git unstage %<CR><CR>:call GitUpdateStatusLine()<CR>
" Revert file to previous commited version
nnoremap <silent> vfr :mkview!<CR>:Gread<CR>:loadview<CR>:call GitUpdateStatusLine()<CR>
" Display diff of file with previous version
nnoremap <silent> vfd :Gdiff<CR>
" Display commits and commiters on the left side
nnoremap <silent> vfb :Gblame<CR>
" }}}
" [c]ommits {{{
" Commit
nnoremap <silent> vcc :Gcommit -v<CR>:resize<CR>
" Commit all
nnoremap <silent> vca :Git add --all .<CR>:Gcommit -v<CR>:resize<CR>
" }}}
" working [d]irectory {{{
nnoremap <silent> vdl :Gstatus<CR>:resize<CR>
" }}}
" [r]emote {{{
" Push to remote
nnoremap <silent> vrps :Git push<CR>
" Pull from remote
nnoremap <silent> vrpl :Git pull<CR>
" }}}

" STATUSLINE
" The status line contain a git indicator whose color change based on the
" status of the current file (modified, staged, commited). This will
" automatically be updated anytime a file is loaded or saved.
let b:git_status = ""

" GitGetRoot {{{
" Returns path of the git root of specified filepath. Returns empty string if
" not a git repo. Reset on every loading of this page, otherwise kept in cache.
if exists('b:git_root')
	unlet b:git_root
endif
function! GitGetRoot(filepath)
	" Caching
	if exists('b:git_root')
		return b:git_root
	endif

	let b:git_root = ""

	let filepath = ShellEscapeForDoubleQuotes(fnamemodify(a:filepath, ':h'))
	let output = system('cd "'.filepath.'" && git rev-parse --show-toplevel')
	if output !~ '^fatal'
		let b:git_root = StrTrim(output)
	endif

	return b:git_root
endfunction
" }}}
" GitIsInRepo {{{
" Returns 1 if specified filepath is in a git repo, 0 otherwise.
function! GitIsInRepo(filepath)
	return GitGetRoot(a:filepath) == "" ? 0 : 1
endfunction
" }}}
" GitGetStatus {{{
" Returns status of specified file in git repo. Possible values are "clean",
" "staged" or "dirty".
function! GitGetStatus(filepath)
	" Quick fail if not a git repo
	if GitIsInRepo(a:filepath) == 0
		return ""
	endif

	" Finding the status output for this file
	let root = ShellEscapeForDoubleQuotes(GitGetRoot(a:filepath))
	let file = ShellEscapeForDoubleQuotes(a:filepath)
	let gitcommand = 'cd "'.root.'" && git status --porcelain --short "'.file.'"'
	let output = system(gitcommand)

	" File is either new or modified, it is dirty
	if output =~# '^??' || output =~# '^ . '
		return "dirty"
	endif
	" File is staged
	if output =~# '^. '
		return "staged"
	endif
	" None of the above, the file is clean
	return "clean"
endfunction
" }}}
" GitUpdateStatusLine {{{
function! GitUpdateStatusLine()
	let b:git_status = GitGetStatus(expand('%:p'))
endfunction
" }}}

" Updating status line value when moving through buffers
augroup git_statusline
	au BufWritePost,BufEnter * call GitUpdateStatusLine()
augroup END

