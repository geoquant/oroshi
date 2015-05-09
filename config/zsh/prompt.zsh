# Fancy prompt.

# init
setopt PROMPT_SUBST
autoload -U promptinit
promptinit

PROMPT='${promptUsername}$(getPromptExitCode)${promptHostname}:$(getPromptPath)$(getPromptTrash)$(getPromptHash) '
RPROMPT='$(getPromptRepoIndicator)'

# Colorize {{{
function colorize() {
  echo "$FG[$promptColor[$2]]$1$FX[reset]"
}
# }}}

# User {{{
promptUsername=$(colorize '%n' 'username')
# }}}

# Exit code {{{
function getPromptExitCode() {
  # Color the @ if last command was an error
  if [[ $? > 0 ]]; then
    echo $(colorize '@'  'lastCommandFailed')
  else
    echo "@"
  fi
}
# }}}

# Hostname {{{
promptHostname=$(colorize '%m' 'hostname')
# }}}

# Path {{{
# This will return a formatted path.
# - If more than 4 directories, will only keep the first and the last two
# - Will prepend a ! and display it in red if not writable
function getPromptPath() {
  local promptPath=$PWD
  local splitPath
  splitPath=(${(s:/:)PWD})

  # Keep only first and last dirs if too long
  if [[ ${#splitPath[*]} -ge 4 ]]; then
    promptPath=/${splitPath[1]}/../${splitPath[-2]}/${splitPath[-1]}/
  fi

  if [[ $promptPath = $HOME ]]; then
    promptPath=' '
  fi

  local pathColor='pathWritable'
  if [[ ! -w $PWD ]]; then
    pathColor='pathNotWritable'
  fi

  echo $(colorize $promptPath $pathColor)
}
# }}}

# Trash {{{
function getPromptTrash() {
  if ! trash-exists; then
    echo " "
  else
    echo $(colorize '_' 'hasTrash')
  fi
}
# }}}

# Hash {{{
function getPromptHash() {
  if ! git-is-repository; then
    echo "%#"
  else
    echo "$(getPromptSubmodule)$(getPromptStash)$(getPromptHashGit)"
  fi
}
# }}}

# Stash {{{
function getPromptStash() {
  if git stash show &>/dev/null; then
    echo $(colorize '  ' 'stash')
  fi
}
# }}}

# Submodule {{{
function getPromptSubmodule() {
  if git is-submodule; then
    echo $(colorize '  ' 'submodule')
  fi
}
# }}}

# Git Hash {{{
function getPromptHashGit() {
  # Staged files
  if git-directory-has-staged-files; then
    echo $(colorize '±' 'repoStaged')
    return
  fi

  # Modified, deleted or newly added files
  if git-directory-is-dirty; then
    echo $(colorize '±' 'repoDirty')
    return
  fi

  echo $(colorize '±' 'repoClean')
}
# }}}

# Repo indicator {{{
function getPromptRepoIndicator() {
  if ! git-is-repository; then
    echo ""
  else
    echo "$(getPromptTag)$(getPromptRebase)$(getPromptBranch)"
  fi
}
# }}}

# Branch {{{
function getPromptBranch() {
  local branchName="$(git branch-current)"
  local branchColor='branchDefault'

  # Not in a branch
  if [[ $branchName = '' ]]; then
    return;
  fi

  # In detached head, we stop now
  if [[ $branchName = 'HEAD' ]]; then
    branchColor='branchDetached'
    branchName="$(git commit-current) "
    echo $(colorize $branchName $branchColor)
    return
  fi

  if [[ $branchName = 'master' ]]; then
    branchColor='branchMaster'
  fi
  if [[ $branchName = 'release' ]]; then
    branchColor='branchRelease'
  fi
  if [[ $branchName = 'develop' ]]; then
    branchColor='branchDevelop'
  fi
  if [[ $branchName =~ '^feature/' ]]; then
    branchColor='branchFeature'
    branchName=${branchName//feature\//}
  fi
  if [[ $branchName =~ '^(bugfix|hotfix|fix)/' ]]; then
    branchColor='branchFix'
    branchName="${branchName//bugfix\//}"
    branchName="${branchName//hotfix\//}"
    branchName="${branchName//fix\//}"
    branchName="${branchName} "
  fi
  if [[ $branchName =~ '^review/' ]]; then
    branchColor='branchReview'
    branchName="${branchName//review\//}  "
  fi
  if [[ $branchName =~ '^test/' ]]; then
    branchColor='branchTest'
    branchName="${branchName//test\//} "
  fi
  if [[ $branchName =~ '^perf/' ]]; then
    branchColor='branchPerf'
    branchName="${branchName/perf\//} "
  fi
  if [[ $branchName = 'gh-pages' ]]; then
    branchColor='branchGhPages'
    branchName="$branchName  "
  fi

  # Adding the remote if different from origin
  local remoteName="$(git remote-current)"
  if [[ $remoteName != 'origin' && $remoteName != '' ]]; then
    branchName="$remoteName $branchName"
  fi

  # Adding push/pull indicator
  local pushPullSymbol="$(getPromptPushPull)"
  if [[ $pushPullSymbol != '' ]]; then
    branchName="${pushPullSymbol} ${branchName}"
  fi

  echo $(colorize $branchName $branchColor)
}
# }}}

# Push/Pull {{{
function getPromptPushPull() {
  local EXIT_CODE_IDENTICAL=0
  local EXIT_CODE_AHEAD=1
  local EXIT_CODE_BEHIND=2
  local EXIT_CODE_DIVERGED=3
  local EXIT_CODE_NEVER_PUSHED=4
  local remoteStatus
  remoteStatus="$(git-branch-remote-status)$?"

  case "$remoteStatus" in
    $EXIT_CODE_AHEAD)
      echo " "
      ;;
    $EXIT_CODE_BEHIND)
      echo " "
      ;;
    $EXIT_CODE_DIVERGED)
      echo " "
      ;;
    $EXIT_CODE_NEVER_PUSHED)
      echo ""
      ;;
  esac
}
# }}}

# Tag {{{
function getPromptTag() {
  local tagName="$(git tag-current)"
  if [[ $tagName = '' ]]; then
    return
  fi
  echo $(colorize "$tagName " 'tag')
}
# }}}

# Rebase {{{
function getPromptRebase() {
  return
  local gitRoot="$(git root)"
  local rebaseDir="${gitRoot}/.git/rebase-apply"

  # No rebase in progress
  if [[ ! -r $rebaseDir/rebasing ]]; then
    return
  fi

  local maxRebase="$(cat $rebaseDir/last)"
  local nextRebase="$(cat $rebaseDir/next)"
  echo $(colorize "${nextRebase}/${maxRebase}   " 'rebase')
}
# }}}

# chpwd() {{{
function chpwd() {
  # Set current path as the window title
  print -Pn "\e]2;%~/\a"
}
# }}}
