{ pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "IBMPlexMono" "JetBrainsMono" ]; })
      terminus-nerdfont
      terminus_font
      iosevka
      unifont
    ];
  
    enableDefaultFonts = false;
  
    fontconfig.defaultFonts = {
      serif = [ "Unifont" ];
      sansSerif = [ "Unifont" ];
      monospace = [ "Unifont" ];
    };
  
  };
}
