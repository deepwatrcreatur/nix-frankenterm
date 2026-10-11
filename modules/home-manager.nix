self:
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.frankenterm;
in
{
  options.programs.frankenterm = {
    enable = lib.mkEnableOption "FrankenTerm (ft) - swarm-native terminal platform for AI agent fleets";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
      defaultText = lib.literalExpression "inputs.nix-frankenterm.packages.\${pkgs.stdenv.hostPlatform.system}.default";
      description = "The FrankenTerm package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
