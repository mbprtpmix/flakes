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
      ls = "exa --color=always -l --group-directories-first";
      ll = "exa --color=always -al --group-directories-first";
    };
    localVariables = {
      PROMPT = "%F{red}>%f%F{yellow}>%f%F{green}>%f ";
    };
    initExtra = ''
      echo -en "\033[6 q"
    '';
  };
}
