# Color aliases
PURPLE='\033[0;35m'
RED='\033[0;31m'
BROWN_ORANGE='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Other aliases
alias beep="echo -ne '${CYAN}[press Ctrl+C to stop...]${NC}' && while true; do echo -ne '\007' && sleep 1.2; done"

# Git aliases
alias drso='grshb develop develop'
alias ga='git add'
alias gaa='ga -A'
alias gb='git branch'
alias gbd='gb -d'
alias gbD='gb -D'
alias gbl='gb -l'
alias gbu='gb -u'
alias gbud='gbu origin/develop'
alias gc='gaa && git commit'
alias gco='git checkout'
alias gcob='gco -b'
alias gcod='gco develop'
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
alias grsh='grs --hard'
alias grshd='gfo && grsh origin/develop'
alias grsm='gfo && grsh origin/master'
alias grso='grshb'
alias grss='grs --soft'
alias grssd='gfo && grss origin/develop'
alias grssh='grss HEAD^'
alias grsso='grssb'
alias gsl='gstash list'
alias gspop='gstash pop'
alias gst='git status'
alias gstash='git stash'
alias mrso='grshb master master'

HEADER_COLOR=$PURPLE
ERROR_COLOR=$RED
CMD_COLOR=$BROWN_ORANGE
BRANCH_COLOR=$CYAN
SEPARATOR="------------------------------------------------------------"

grsb() {

    unset upstream
    unset current_branch
    unset remote_branch
    unset source
    unset target
    unset remote

    case $# in
    1)
        remote_branch=@{upstream}
        ;;
    2)
        source=$2
        ;;
    3)
        target=$2
        source=$3
        echo -e "${CMD_COLOR}git checkout ${BRANCH_COLOR}$target${NC}"
        gco "$target"
        validate_result $? "${CMD_COLOR}git checkout ${BRANCH_COLOR}$target${NC}"
        echo -e $SEPARATOR
        ;;
    *)
        echo -en "${ERROR_COLOR}"
        echo -e $SEPARATOR
        echo -e "error: bad number of arguments"
        echo -en $SEPARATOR
        echo -en "${NC}"
        return 1
        ;;
    esac
                                                                                        # | Variable Name  | Example 1      | Example 2 | Example 3 | Example 4     |
    upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2>/dev/null) # | upstream       | origin/develop | develop   | -         | origin/master |
    current_branch=$(git symbolic-ref -q --short HEAD)                                  # | current_branch | develop        | develop   | test      | master        |
    remote=$(echo ${upstream%"$current_branch"})                                        # | remote         | origin/        | -         | -         | origin/       |
    remote=$(echo ${remote%"/"})                                                        # | remote         | origin         | -         | -         | origin        |
    remote_branch=${remote_branch:-$remote/$source}                                     # | remote_branch  | origin/$source | /$source  | /$source  | @{upstream}   |
    remote_branch=$(echo ${remote_branch#"/"})                                          # | remote_branch  | origin/$source | $source   | $source   | @{upstream}   |

    if [[ -z "$remote" ]]; then
        echo -en "${ERROR_COLOR}"
        echo -e $SEPARATOR
        echo -e "error: missing remote"
        echo -e $SEPARATOR
        echo -en "${NC}"
        return 1
    fi

    echo -e "${CMD_COLOR}git fetch ${BRANCH_COLOR}$remote${NC}"
    gf
    validate_result $? "${CMD_COLOR}git fetch ${BRANCH_COLOR}$remote${NC}"
    echo -e $SEPARATOR

    echo -e "${CMD_COLOR}will reset local: ${BRANCH_COLOR}$current_branch${NC}"
    echo -e "${CMD_COLOR}to remote: ${BRANCH_COLOR}$remote_branch${NC}"
    echo -e $SEPARATOR

    read -p "$(echo -e "${HEADER_COLOR}[press Enter to continue, or Ctrl+C to cancel]\n${NC}$SEPARATOR")"

    echo -e "${CMD_COLOR}git reset $1 ${BRANCH_COLOR}$remote_branch${NC}"
    grs $1 "$remote_branch"
    validate_result $? "${CMD_COLOR}git reset $1 ${BRANCH_COLOR}$remote_branch${NC}"
    echo -e $SEPARATOR
}

grshb() {
    echo -e $SEPARATOR
    echo -e "${HEADER_COLOR}[Git Reset Hard Branch]${NC}\n(local) ${BRANCH_COLOR}$1${NC} -> (remote) ${BRANCH_COLOR}$remote_branch${NC}"
    echo -e $SEPARATOR

    grsb --hard "$@"
    validate_result $? "${CMD_COLOR}grsb --hard ${BRANCH_COLOR}$@${NC}"

    if [ $? -eq 0 ]; then
        echo -e "${HEADER_COLOR}[cleanup the untracked files]${NC}"
        echo -e "${CMD_COLOR}git clean -df${NC}"
        git clean -df
        validate_result $? "${CMD_COLOR}git clean -df${NC}"
        echo -en $SEPARATOR
    fi
}

grssb() {
    echo -e $SEPARATOR
    echo -e "${HEADER_COLOR}[Git Reset Soft Branch]${NC}"
    echo -e $SEPARATOR

    grsb --soft "$@"
    validate_result $? "${CMD_COLOR}grsb --soft ${BRANCH_COLOR}$@${NC}"
}

validate_result() {
    if [ $1 -ne 0 ]; then
        echo -en "${ERROR_COLOR}"
        echo -e $SEPARATOR
        echo -e "error: failed to execute: $2"
        echo -en "${ERROR_COLOR}"
        echo -en $SEPARATOR
        echo -en "${NC}"
        kill -INT $$
    fi
}
