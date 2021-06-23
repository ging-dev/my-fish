# Gingdev

# Is git dirty?
function _fishblocks_git_dirty -d 'Checks whether or not the current branch has tracked, modified files'
    not git diff --no-ext-diff --quiet --exit-code 2>/dev/null && echo 0
end

# Is git has untracked files?
function _fishblocks_git_untracked -d 'Checks whether or not the current repository has untracked files'
    command git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- :/ >/dev/null 2>&1 && echo 0
end

# Is PWD a git directory?
function _fishblocks_git_directory -d 'Checks whether or not the current directory is a or part of a git repository'
    set -l repo_info (command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree HEAD 2>/dev/null)

    echo $repo_info
end

# Set git status color
function _fishblocks_git_status -d 'Returns color based on the previous command status'
    if [ (_fishblocks_git_directory) ]
        if [ (_fishblocks_git_untracked) ] &&  not [ (_fishblocks_git_dirty) ]
            set git_color brgreen
        else if [ (_fishblocks_git_dirty) ]
            set git_color yellow
        else
            set git_color green
        end
    else
        set git_color white
    end

    echo $git_color
end

# OS icon
function _fishblocks_os_icon -d 'Returns OS icon'
    echo \uf31c
end

# Blocks

# Distro/OS icon block
function _block_icon -d 'Returns icon block'
    echo (set_color -b blue white) (_fishblocks_os_icon)' '
end

# SSH block
function _block_ssh -d 'Returns SSH block'
    set block
    if set -q SSH_TTY
        set block (set_color -b bryellow -o black)' SSH '
    end

    echo $block
end

# user@host block
function _block_user_host -d 'Returns username and hostname block'
    set -l user_hostname $USER #@(prompt_hostname)

    if [ $USER = 'root' ]
        set user_bg red
    else if [ $USER != (logname) ]
        set user_bg yellow
    else
        set user_bg brwhite
    end

    # If we're running via SSH.
    if set -q SSH_TTY
        set user_bg brblack
        set user_hostname (set_color -o brblue)$USER(set_color -o brred)@(set_color -o brgreen)(prompt_hostname)
    end

    echo (set_color -b $user_bg -o black) \uf2bd $user_hostname' '
end

# PWD block
function _block_pwd -d 'Returns PWD block'
    # Check working directory if writable
    if test -w $PWD
        set pwd_color bryellow #(_fishblocks_git_status)
    else
        set pwd_color red
    end

    echo (set_color -b yellow -o $pwd_color) \uf115 (prompt_pwd)' '
end

# Left-hand prompt
function fish_prompt
    # Window title
    if [ $TERM = 'linux' ]
        printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
        return
    end

    # Print right-hand prompt
    echo (_block_icon)(_block_ssh)(_block_user_host)(_block_pwd)(set_color normal)' '
end
