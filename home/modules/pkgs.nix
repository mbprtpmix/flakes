{ pkgs, ... }:

{
  # pkgs
  home.packages = with pkgs; [
    imagemagick
    sxiv
    ueberzug
    xfce.xfce4-pulseaudio-plugin
    brave
    xsel
  ];
}
