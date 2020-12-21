{ config, lib, pkgs, ... }:
let

  profiles = (
    if (builtins.pathExists ./deployment.nix) then
      ./custom-additions.nix
      ./deployment.nix
    else
      ./custom-additions.nix
  );

in {
  imports = [
    <nixpkgs/nixos/modules/virtualisation/openstack-config.nix>
    profiles
  ];

  environment.etc = {
    custom-additions = {
      source = ./custom-additions.nix;
      target = "nixos/custom-additions.nix";
      mode = "0600";
    };
  };

}
