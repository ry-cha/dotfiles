# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

if [[ -t 0 ]]; then
  if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
  else
    # Oh My Zsh normally initializes Tab completion.
    autoload -Uz compinit && compinit
    if [[ -r "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
      source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"
    fi
  fi

  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

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

if (( $+commands[go] )); then
  PATH="$PATH:$(go env GOPATH)/bin"
fi
# export JAVA_HOME=`/usr/libexec/java_home -v 21.0.2`
if java_home=$(/usr/libexec/java_home -v 25 2>/dev/null); then
  export JAVA_HOME="$java_home"
fi
# export PATH="$JAVA_HOME/bin:$PATH"

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi
if [[ -t 0 ]] && (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

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

alias ghidra='/opt/homebrew/Caskroom/ghidra/11.3-20250205/ghidra_11.3_PUBLIC/ghidraRun'
alias zookeeper='zookeeper-server-start /opt/homebrew/etc/zookeeper/zoo.cfg'
alias kafka='kafka-server-start /opt/homebrew/etc/kafka/server.properties'
export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/ryanchan/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH="$HOME/.local/bin:$PATH"
export MAHORUNNER_ROOT="$HOME/Developer"
export MAHORUNNER_PROVIDER="codex"

if [[ -o interactive && -t 0 ]]; then
  ZSH_AUTOSUGGESTIONS=${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_SYNTAX_HIGHLIGHTING=${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  [[ -r $ZSH_AUTOSUGGESTIONS ]] && source "$ZSH_AUTOSUGGESTIONS"
  # Load highlighting after plugins that register line-editor widgets, including fzf.
  [[ -r $ZSH_SYNTAX_HIGHLIGHTING ]] && source "$ZSH_SYNTAX_HIGHLIGHTING"
fi
