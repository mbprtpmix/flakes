{ config, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    defaultKeymap = "viins";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";
    shellAliases = {
      ls = "ls --color";
    };
    localVariables = {
      PROMPT = "%F{red}>%f%F{yellow}>%f%F{green}>%f ";
    };
    initExtra = # Bar cursor
      ''
        echo -en "\033[6 q"
    '';
  };
}