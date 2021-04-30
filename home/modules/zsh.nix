{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autocd = true;
    defaultKeymap = "viins";
    dirHashes = {
      dl = "$HOME/Downloads";
      docs = "$HOME/Documents";
      code = "$HOME/Documents/code";
      dots = "$HOME/Documents/code/dotfiles";
      pics = "$HOME/Pictures";
      vids = "$HOME/Videos";
    };
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      path = "${config.xdg.dataHome}/zsh_history";
    };
    initExtra = ''
            # autoloads
            autoload -U history-search-end
            autoload -Uz vcs_info
            autoload edit-command-line
            # configure prompt
            PS1="%B%F{yellow}%n%F{green}@%F{blue}%M %F{magenta}%~ %(?.%F{green}%#.%F{red}%#)%f "
            # search history based on what's typed in the prompt
            # group functions
            zle -N history-beginning-search-backward-end history-search-end
            zle -N history-beginning-search-forward-end history-search-end
            # bind functions to up and down arrow keys
            bindkey "^[[A" history-beginning-search-backward-end
            bindkey "^[[B" history-beginning-search-forward-end
            # allow editing the command in $EDITOR with ^E
            zle -N edit-command-line
            bindkey '^e' edit-command-line
            # change cursor shape for different vi modes
            function zle-keymap-select {
              if [[ $KEYMAP == vicmd ]] ||
                 [[ $1 = 'block' ]]; then
                echo -ne '\e[1 q'
              elif [[ $KEYMAP == main ]] ||
                   [[ $KEYMAP == viins ]] ||
                   [[ $KEYMAP = '\' ]] ||
                   [[ $1 = 'beam' ]]; then
                echo -ne '\e[5 q'
              fi
            }
            zle -N zle-keymap-select
            zle-line-init() {
              echo -ne "\e[5 q"
            }
            zle -N zle-line-init
            echo -ne '\e[5 q' # Use beam shape cursor on startup.
            preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
            # git integration
            autoload -Uz vcs_info
            precmd_vcs_info() { vcs_info }
            precmd_functions+=( precmd_vcs_info )
            setopt prompt_subst
            RPROMPT=\$vcs_info_msg_0_
            zstyle ':vcs_info:git:*' formats '%F{blue}(%b)%r%f'
            zstyle ':vcs_info:*' enable git
            # case insensitive tab completion
            zstyle ':completion:*' completer _complete _ignored _approximate
            zstyle ':completion:*' list-colors '\'
            zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
            zstyle ':completion:*' menu select
            zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
            zstyle ':completion:*' verbose true
            _comp_options+=(globdots)
      			${builtins.readFile ./nix-completions.sh}
          '';
    shellAliases = {
      grep = "grep --color";
      ip = "ip --color";
      l = "exa -l";
      la = "exa -la";
      md = "mkdir -p";
      ga = "git add";
      gb = "git branch";
      gc = "git commit";
      gca = "git commit --amend";
      gcm = "git commit -m";
      gco = "git checkout";
      gcb = "git checkout -b";
      gd = "git diff";
      gds = "git diff --staged";
      gp = "git push";
      gpl = "git pull";
      gl = "git log";
      gs = "git status --short";
      gss = "git status";
      us = "systemctl --user";
      rs = "doas systemctl";
    };
    shellGlobalAliases = { exa = "exa --icons --git"; };
  };
}