# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

OS_TYPE=$(uname)
case "$OS_TYPE" in
    Linux)
        # ubuntu
        ZSH_AUTOSUGGESTIONS=/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_SYNTAX_HIGHLIGHTING=/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        FZF_INIT="[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh"
        PATH="$HOME/.local/kitty.app/bin:$PATH"
        ;;
    Darwin)
        # macOS
        ZSH_AUTOSUGGESTIONS=/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_SYNTAX_HIGHLIGHTING=/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        FZF_INIT="source <(fzf --zsh)"
        PATH="$PATH:$(go env GOPATH)/bin"
        export JAVA_HOME=`/usr/libexec/java_home -v 21.0.2`
        ;;
esac

[[ -f $ZSH_AUTOSUGGESTIONS ]] && source $ZSH_AUTOSUGGESTIONS
[[ -f $ZSH_SYNTAX_HIGHLIGHTING ]] && source $ZSH_SYNTAX_HIGHLIGHTING
eval "$(zoxide init zsh)"
eval $FZF_INIT

alias cd="z"

export EDITOR="nvim"
export MANPAGER="nvim +Man!"

# yazi
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# linux aliases
if [[ "$OS_TYPE" == "Linux" ]]; then
    alias subaru='bash ~/subaru.sh'
    alias honda='bash ~/honda.sh'
    alias rice='bash ~/rice.sh'
fi

# macOS aliases
if [[ "$OS_TYPE" == "Darwin" ]]; then
    alias ghidra='/opt/homebrew/Caskroom/ghidra/11.3-20250205/ghidra_11.3_PUBLIC/ghidraRun'
    alias zookeeper='zookeeper-server-start /opt/homebrew/etc/zookeeper/zoo.cfg'
    alias kafka='kafka-server-start /opt/homebrew/etc/kafka/server.properties'
fi

# terminal setting ghostty/kitty -> xterm-256color
has_terminfo() {
    # returns 0 if terminal type is installed
    infocmp "$1" >/dev/null 2>&1
}
ORIG_TERM="$TERM"
if ! has_terminfo "$TERM"; then # downgrade
    export TERM="xterm-256color"
fi

if [[ -o login ]]; then
    [[ -f /etc/motd ]] && cat /etc/motd
fi
