# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Function to source files if they exist
function zsh_add_file() {
    [ -f "$1" ] && source "$1"
}

zsh_add_file $HOME/.config/zsh/vim.zsh
zsh_add_file $HOME/.config/shell/alias
zsh_add_file $HOME/.config/zsh/plugins.zsh
zsh_add_file $HOME/.config/zsh/fzf.zsh

### thefuck
if [ -f /usr/bin/thefuck ]; then
    eval $(thefuck --alias)
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

(( ! ${+functions[p10k]} )) || p10k finalize
