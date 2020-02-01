{ config, lib, pkgs, ... }:
let

in {
  imports = [ <nixpkgs/nixos/modules/virtualisation/openstack-config.nix> ];

  boot = {
    kernelParams = lib.mkForce [ "console=tty1" "console=ttyS0" "panic=1" "boot.panic_on_fail" "LANG=en_US.UTF-8" ];
    initrd.kernelModules = [ "virtio_scsi" ];
    kernelModules = [ "virtio_pci" "virtio_net" ];
    loader = {
      timeout = lib.mkForce 5;
      # because our image use virtio-scsi driver.
      grub.device = lib.mkForce "/dev/sda"; # default vda
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

}
