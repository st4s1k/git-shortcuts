# Colors ($'...' syntax works in bash, zsh, ksh — escapes resolved at assignment)
NC=$'\e[0m'
WHITE=$'\e[97m'
RED=$'\e[31m'
GREEN=$'\e[32m'
BROWN_ORANGE=$'\e[33m'
BLUE=$'\e[34m'
PURPLE=$'\e[35m'
CYAN=$'\e[36m'
LIGHT_GRAY=$'\e[37m'
DARK_GRAY=$'\e[90m'
LIGHT_RED=$'\e[91m'
LIGHT_GREEN=$'\e[92m'
LIGHT_YELLOW=$'\e[93m'
LIGHT_BLUE=$'\e[94m'
LIGHT_MAGENTA=$'\e[95m'
LIGHT_CYAN=$'\e[96m'

# Project branch defaults (override in your project's shell profile or .env)
: "${PROJECT_DEV_BRANCH:=develop}"
: "${PROJECT_MAIN_BRANCH:=master}"

# Other aliases
alias beep="printf '%s' '${CYAN}[press Ctrl+C to stop...]${NC}' && while true; do printf '\007' && sleep 1.2; done"
alias mci="mvn clean install"
alias mcist="mci -Dmaven.test.skip=true"

# Git aliases
alias ga='git add'
alias gaa='ga -A'
alias gb='git branch'
alias gbd='gb -d'
alias gbD='gb -D'
alias gbl='gb -l'
alias gbu='gb -u'
alias gbud='gbu origin/$PROJECT_DEV_BRANCH'
alias gc='gaa && git commit'
alias gco='git checkout'
alias gcob='gco -b'
alias gcod='gco $PROJECT_DEV_BRANCH'
alias gf='git fetch'
alias gfo='gf origin'
alias gp='git push'
alias gpf='gp -f'
alias gpfu='gpf -u origin HEAD'
alias gpu='gp -u origin HEAD'
alias gpull='git pull'
alias grm='git rm'
alias grmc='grm --cached'
alias grs='git reset'

alias grsho='git_reset_hard_branch'
alias grshd='grsho $PROJECT_DEV_BRANCH'
alias grshm='grsho $PROJECT_MAIN_BRANCH'
alias grso='grsho'
alias grsd='grshd'
alias grsm='grshm'
alias drsho='grsho $PROJECT_DEV_BRANCH $PROJECT_DEV_BRANCH'
alias mrsho='grsho $PROJECT_MAIN_BRANCH $PROJECT_MAIN_BRANCH'
alias drso='drsho'
alias mrso='mrsho'

alias grsso='git_reset_soft_branch'
alias grssd='grsso $PROJECT_DEV_BRANCH'
alias grssm='grsso $PROJECT_MAIN_BRANCH'
alias drsso='grsso $PROJECT_DEV_BRANCH $PROJECT_DEV_BRANCH'
alias mrsso='grsso $PROJECT_MAIN_BRANCH $PROJECT_MAIN_BRANCH'

alias grss='grs --soft'
alias grssh='grss HEAD^'
alias gsl='gstash list'
alias gspop='gstash pop'
alias gst='git status'
alias gstash='git stash'

HEADER_COLOR=$PURPLE
ERROR_COLOR=$RED
CMD_COLOR=$BROWN_ORANGE
BRANCH_COLOR=$CYAN
SEPARATOR="------------------------------------------------------------"

# Helper: print a formatted error message
_git_error() {
    printf "%s\n" "${ERROR_COLOR}${SEPARATOR}"
    printf "error: %s\n" "$1"
    printf "%s\n" "${SEPARATOR}${NC}"
}

# Helper: check exit code and print error on failure
# Usage: _git_validate $? "command description" || return 1
_git_validate() {
    if [[ $1 -ne 0 ]]; then
        _git_error "failed to execute: $2"
        return 1
    fi
}

# Helper: verify we're inside a git repository
_git_require_repo() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        _git_error "not a git repository"
        return 1
    fi
}

git_reset_branch() {
    _git_require_repo || return 1

    local check_user_input=true
    local source="" target="" remote_branch=""
    local upstream current_branch remote
    local reset_mode="" _a1="" _a2="" _a3=""
    local _argc=0

    # Parse arguments: extract -y flag, collect the rest (no arrays — portable)
    while [[ $# -gt 0 ]]; do
        if [[ "$1" == "-y" ]]; then
            check_user_input=false
        else
            _argc=$((_argc + 1))
            case $_argc in
                1) _a1="$1" ;;
                2) _a2="$1" ;;
                3) _a3="$1" ;;
            esac
        fi
        shift
    done

    reset_mode="$_a1"

    case $_argc in
    1)
        # git_reset_branch --hard
        remote_branch="@{upstream}"
        ;;
    2)
        # git_reset_branch --hard <source>
        source="$_a2"
        ;;
    3)
        # git_reset_branch --hard <target> <source>
        target="$_a2"
        source="$_a3"
        printf "%s\n" "${CMD_COLOR}git checkout ${BRANCH_COLOR}${target}${NC}"
        git checkout "$target"
        _git_validate $? "git checkout $target" || return 1
        printf "%s\n" "$SEPARATOR"
        ;;
    *)
        _git_error "bad number of arguments: $_argc"
        return 1
        ;;
    esac

    upstream=$(git rev-parse --symbolic-full-name --abbrev-ref "@{upstream}" 2>/dev/null)
    current_branch=$(git symbolic-ref -q --short HEAD)
    remote="${upstream%"$current_branch"}"
    remote="${remote%/}"
    remote_branch="${remote_branch:-${remote}/${source}}"
    remote_branch="${remote_branch#/}"

    if [[ -z "$remote" ]]; then
        _git_error "missing remote (no upstream set for current branch)"
        return 1
    fi

    printf "%s\n" "${CMD_COLOR}git fetch ${BRANCH_COLOR}${remote}${NC}"
    git fetch "$remote"
    _git_validate $? "git fetch $remote" || return 1
    printf "%s\n" "$SEPARATOR"

    printf "%s\n" "${CMD_COLOR}will reset local: ${BRANCH_COLOR}${current_branch}${NC}"
    printf "%s\n" "${CMD_COLOR}to remote: ${BRANCH_COLOR}${remote_branch}${NC}"
    printf "%s\n" "$SEPARATOR"

    if $check_user_input; then
        printf "%s\n" "${HEADER_COLOR}[press Enter to continue, or Ctrl+C to cancel]${NC}"
        printf "%s\n" "$SEPARATOR"
        read _discard
    fi

    printf "%s\n" "${CMD_COLOR}git reset ${reset_mode} ${BRANCH_COLOR}${remote_branch}${NC}"
    git reset "$reset_mode" "$remote_branch"
    _git_validate $? "git reset $reset_mode $remote_branch" || return 1
    printf "%s\n" "$SEPARATOR"
}

git_reset_hard_branch() {
    printf "%s\n" "$SEPARATOR"
    printf "%s\n" "${HEADER_COLOR}[Git Reset Hard Branch]${NC}"
    printf "%s\n" "$SEPARATOR"

    git_reset_branch --hard "$@" || return 1

    printf "%s\n" "${HEADER_COLOR}[cleanup the untracked files]${NC}"
    printf "%s\n" "${CMD_COLOR}git clean -df${NC}"
    git clean -df
    _git_validate $? "git clean -df" || return 1
    printf "%s\n" "$SEPARATOR"
}

git_reset_soft_branch() {
    printf "%s\n" "$SEPARATOR"
    printf "%s\n" "${HEADER_COLOR}[Git Reset Soft Branch]${NC}"
    printf "%s\n" "$SEPARATOR"

    git_reset_branch --soft "$@" || return 1
}
