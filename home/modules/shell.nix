{ config, ... }:

{
  # add locations to $PATH
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];
}