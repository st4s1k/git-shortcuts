# git-shortcuts

Portable shell aliases and functions for common Git workflows. Works in **bash**, **zsh**, and **ksh**.

## Setup

Source the file from your shell profile:

```sh
# ~/.bashrc, ~/.zshrc, or equivalent
source /path/to/git-shortcuts/.bashrc
```

## Configuration

Two variables control which branches the "dev" and "main" aliases target. They default to `develop` and `master` if not set:

```sh
export PROJECT_DEV_BRANCH="develop"
export PROJECT_MAIN_BRANCH="master"
```

Override them before sourcing, or in a per-project `.env` / shell profile.

## Aliases

### Git basics

| Alias   | Command                        |
| ------- | ------------------------------ |
| `ga`    | `git add`                      |
| `gaa`   | `git add -A`                   |
| `gb`    | `git branch`                   |
| `gbd`   | `git branch -d`                |
| `gbD`   | `git branch -D`                |
| `gbl`   | `git branch -l`                |
| `gbu`   | `git branch -u`                |
| `gbud`  | `git branch -u origin/$DEV`    |
| `gc`    | `git add -A && git commit`     |
| `gco`   | `git checkout`                 |
| `gcob`  | `git checkout -b`              |
| `gcod`  | `git checkout $DEV`            |
| `gf`    | `git fetch`                    |
| `gfo`   | `git fetch origin`             |
| `gp`    | `git push`                     |
| `gpf`   | `git push -f`                  |
| `gpfu`  | `git push -f -u origin HEAD`   |
| `gpu`   | `git push -u origin HEAD`      |
| `gpull` | `git pull`                     |
| `grm`   | `git rm`                       |
| `grmc`  | `git rm --cached`              |
| `grs`   | `git reset`                    |
| `grss`  | `git reset --soft`             |
| `grssh` | `git reset --soft HEAD^`       |
| `gst`   | `git status`                   |
| `gstash`| `git stash`                    |
| `gsl`   | `git stash list`               |
| `gspop` | `git stash pop`                |

### Reset to remote (hard)

| Alias   | Description                                                          |
| ------- | -------------------------------------------------------------------- |
| `grsho` | Hard-reset current branch to its upstream                            |
| `grshd` | Hard-reset current branch to remote `$DEV`                          |
| `grshm` | Hard-reset current branch to remote `$MAIN`                         |
| `grso`  | *(alias for `grsho`)*                                                |
| `grsd`  | *(alias for `grshd`)*                                                |
| `grsm`  | *(alias for `grshm`)*                                                |
| `drsho` | Checkout `$DEV`, then hard-reset it to remote `$DEV`                |
| `mrsho` | Checkout `$MAIN`, then hard-reset it to remote `$MAIN`              |
| `drso`  | *(alias for `drsho`)*                                                |
| `mrso`  | *(alias for `mrsho`)*                                                |

### Reset to remote (soft)

| Alias   | Description                                                          |
| ------- | -------------------------------------------------------------------- |
| `grsso` | Soft-reset current branch to its upstream                            |
| `grssd` | Soft-reset current branch to remote `$DEV`                          |
| `grssm` | Soft-reset current branch to remote `$MAIN`                         |
| `drsso` | Checkout `$DEV`, then soft-reset it to remote `$DEV`                |
| `mrsso` | Checkout `$MAIN`, then soft-reset it to remote `$MAIN`              |

All reset aliases accept an optional **`-y`** flag to skip the confirmation prompt.

### Other

| Alias   | Command                              |
| ------- | ------------------------------------ |
| `mci`   | `mvn clean install`                  |
| `mcist` | `mvn clean install -Dmaven.test.skip=true` |
| `beep`  | Repeating terminal bell (Ctrl+C to stop) |

## Functions

### `git_reset_hard_branch [source] [target] [-y]`

Fetches from the remote, then **hard-resets** the local branch to match a remote branch, followed by `git clean -df` to remove untracked files.

```
git_reset_hard_branch                       # reset to upstream
git_reset_hard_branch develop               # reset to origin/develop
git_reset_hard_branch feature develop       # checkout feature, reset to origin/develop
git_reset_hard_branch develop develop -y    # skip confirmation
```

### `git_reset_soft_branch [source] [target] [-y]`

Same as above but uses `--soft` reset (keeps changes staged). No `git clean`.

## License

Do whatever you want with it.
