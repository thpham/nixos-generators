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

  system.activationScripts.getty = ''
    mkdir -p /sbin
    ln -sfn ${pkgs.utillinux}/sbin/agetty /sbin/agetty
  '';
  systemd.services."autovt@".enable = lib.mkForce true;

  services.cloud-init.ext4.enable = true;

  networking.timeServers = [ "10.1.1.101" "10.1.1.102" ];
  services.logrotate.enable = true;

  users.motd = "Restricted Access Only";
  ## Add your changes below

  networking.firewall.allowedTCPPorts = [ 80 ];  
  users.users.root.password = "nixos";
  services.openssh.permitRootLogin = lib.mkDefault "yes";
  services.mingetty.autologinUser = lib.mkDefault "root";

}
