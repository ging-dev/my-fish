# Blocks

# Time stamp block
function _block_time_stamp -d 'Returns time stamp block'
    echo (set_color -b cyan -o brcyan) \uf017 (date +%H:%M:%S)' '
end

# Status block
function _block_status -d 'Returns status block'
    if test $status -eq 0
        echo (set_color -b brgreen green)' ✔ '
    else
        echo (set_color -b red yellow)' ✘ '
    end
end

# Git block
function _block_git -d 'Returns Git block'
    set block
    if [ (fish_git_prompt) ]
        set block (set_color -b (_fishblocks_git_status) -o white) \uf418(fish_git_prompt)'  '
    end

    echo $block
end

# Private mode block
function _block_private -d 'Returns private mode block'
    if not test -z $fish_private_mode
        set block (set_color -b black white) \ufaf8
    else
        set block
    end

    echo $block
end

# Right-hand prompt
function fish_right_prompt -d 'Right-hand prompt'
    set block (_block_status)(_block_git)(_block_time_stamp)(_block_private)(set_color normal)

    if [ $TERM = 'linux' ]
        set block
    end

    echo $block
end
