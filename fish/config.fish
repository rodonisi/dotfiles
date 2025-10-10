if test (uname) = Darwin
    /opt/homebrew/bin/brew shellenv | source
end

set -U fish_color_command green

set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
carapace _carapace | source

zoxide init fish --cmd cd | source

function starship_transient_prompt_func
    starship module character
end
starship init fish | source
enable_transience

if test -f ~/.local.fish
    source ~/.local.fish
end
