# ALIAS AND CUSTOM PATH {{{
# Note: We follow the convention of putting manually installed binaries in
# /usr/local/bin. OS installed binaries goes to /usr/bin.
#
# Small scripts that are more of a wrapper for convenient calls will go to
# ~/.oroshi/scripts/bin and ~/.oroshi/scripts/bin/local/{hostname}.
#
# Those last two directories will be added to the path in interactive mode.
#
# Note: If we want to override default commands, we should write an alias that point
# to a custom script for overwriting the command. As alias are not passed on to
# scripts, we avoid overwriting basic commands that some externals tools will
# rely on.
#
# Note: Calling sudo will NOT use any aliases defined, but will use files in
# custom paths.
# }}}

# Custom paths {{{
path=(
	$path
	~/.oroshi/scripts/bin
	~/.oroshi/private/scripts/bin
	~/.oroshi/scripts/bin/local/$(hostname)
	~/.oroshi/private/sripts/bin/local/$(hostname)
)
# }}}
# Fasd {{{
eval "$(fasd --init auto)"
# }}}

# Basic commands {{{
# ls : colors and human readable size
alias ls="ls -vhlp --color=always --group-directories-first"
# grep : colored
alias grep='grep --color=auto'
# tree : colored, show hidden files but hides git/hg. Display non-ASCII chars
alias tree='tree -aNC -I ".hg|.git"'
# watch : colored
alias watch='watch -c '
# diff : colored
alias diff='colordiff'

# Create subdirectories recursively
alias mkdir="mkdir -p"
# rm : use system trash
alias rm='trash'
# rmdir : use system trash
alias rmdir='better-rmdir'
# cp : recursive and verbose
alias cp='cp -rv'
# mv : verbose and interactive if destination exists
alias mv='mv -vi'
# }}}
# Global aliases {{{
alias -g NE='2>/dev/null'
alias -g NO='1>/dev/null'
alias -g T="| tail"
alias -g H="| head"
alias -g G="| grep"
alias -g L="| less -R"
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
# }}}
# Typos {{{
alias sl="ls"
alias mc="mv"
# }}}
# Misc {{{
# cp and mv using rsync and preserving attributes
alias rcp='rsync -ahP'
alias rmv='rsync -ahP --remove-sent-files'
# Scrollable colors
alias spectrum='spectrum L'
# ls with hidden files
alias la="ls -a"
# Tree that only display directories
alias treed='tree -dN'
# Opening nautilus
alias n="nautilus"
# Find a file
function f() { find . -iname "*$1*" }
alias f='f'
# Reload test files
alias rr='reload-tests'
# Mount /dev/sd* to ~/local/mnt/sd*
function mountsd() {
echo "Mounting /dev/sd$1 to ~/local/mnt/sd$1"
sudo mount -t vfat /dev/sd$1 ~/local/mnt/sd$1
cd ~/local/mnt/sd$1
}
# }}}
# GUI apps {{{
alias chrome="gui chromium-browser"
alias disk-utility='gui palimpsest'
alias ebook-viewer='gui ebook-viewer'
alias eog='gui eog'
alias evince="gui evince"
alias vlc='gui vlc'
alias writer='gui libreoffice --writer'
# }}}

# Apt-get {{{
alias apt-get='apt-fast'
alias agi='sudo apt-fast install'
alias agp='sudo apt-fast purge'
alias agr='sudo apt-fast remove'
alias ags='sudo apt-cache search'
alias agu='sudo apt-fast -u install'
alias agc='sudo apt-fast clean'
alias agd='sudo apt-cache show'
# }}}
# Directories {{{
alias cd-='cd -'
alias cdo='cd ~/.oroshi/'
alias cdl='cd ~/local/'
alias cdm='cd ~/local/mnt/'
alias cdt='cd ~/local/tmp/'
alias cdw='cd ~/local/var/www/'
alias cdb='cd ~/Documents/Blog/'
alias cdm='cd ~/Documents/Movies/'
alias cdp='cd ~/Documents/Photos'
alias cdd='cd ~/Documents/Documentation/'
alias cdr='cd ~/Documents/Documentation/server/ruby/Ruby\ 1.9.3\ Doc/'
# }}}
# Nginx {{{
alias ngsta='sudo /etc/init.d/nginx start'
alias ngsto='sudo /etc/init.d/nginx stop'
alias ngrl='sudo /etc/init.d/nginx reload'
alias ngrs='sudo /etc/init.d/nginx restart'
# }}}
#	Oroshi {{{
alias oc="~/.oroshi/scripts/deploy/dircolors && source ~/.zshrc"
alias od="~/.oroshi/deploy && source ~/.zshrc" 
alias ou="cd ~/.oroshi && ~/.oroshi/update"
alias ox="~/.oroshi/scripts/deploy/xmodmap"
alias oz="source ~/.zshrc"
alias oa="source ~/.oroshi/config/zsh/aliases.zsh"
# }}}
# Python {{{
alias py3='python3'
# }}}
# Ruby {{{
# Loading pry in custom dir
# Note: pry has a bug where it loads .pryrc twice if launched in home
alias pry='cd ~/local/tmp/scripts/pry && pry && cd -'
# }}}
# Vim {{{
alias v='vim -p'
alias vv='fasd -e vim'
alias va="vim ~/.oroshi/config/zsh/aliases.zsh"
alias vf="vim ~/.oroshi/config/zsh/filetypes.db.zsh"
alias ve='vim ~/.oroshi/config/vim/vimrc'
# }}}
# Web {{{
# Flushing dns for web testing
alias flushdns="/etc/init.d/dns-clean start"
# Test current internet speed
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test500.zip'
# }}}