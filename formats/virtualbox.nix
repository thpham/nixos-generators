{ modulesPath, config, lib, pkgs, ... }:
let
  params = {
    cpus = 4;
    memory = 4096;
    acpi = "on";
    vram = 32;
    nictype1 = "virtio";
    nic1 = "nat";
    audio = "none";
    rtcuseutc = "on";
    usb = "off";
    mouse = "usbtablet";
  };

in
{
  imports = [
    "${toString modulesPath}/virtualisation/virtualbox-image.nix"
  ];

  system.build.virtualBoxOVA = import "${toString modulesPath}/../lib/make-disk-image.nix" {
    name = "nixos-ova-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";

    inherit pkgs lib config;
    partitionTableType = "legacy";
    diskSize = 51200;

    postVM =
      ''
        export HOME=$PWD
        export PATH=${pkgs.virtualbox}/bin:$PATH
        echo "creating VirtualBox pass-through disk wrapper (no copying involved)..."
        VBoxManage internalcommands createrawvmdk -filename disk.vmdk -rawdisk $diskImage
        echo "creating VirtualBox VM..."
        vmName="NixOS ${config.system.nixos.label} (${pkgs.stdenv.hostPlatform.system})";
        VBoxManage createvm --name "$vmName" --register \
          --ostype ${if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then "Linux26_64" else "Linux26"}
        VBoxManage modifyvm "$vmName" \
          --memory 4096 \
          ${lib.cli.toGNUCommandLineShell { } params}
        VBoxManage storagectl "$vmName" --name SATA --add sata --portcount 4 --bootable on --hostiocache on
        VBoxManage storageattach "$vmName" --storagectl SATA --port 0 --device 0 --type hdd \
          --medium disk.vmdk
        echo "exporting VirtualBox VM..."
        mkdir -p $out
        fn="$out/nixos-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.ova"
        VBoxManage export "$vmName" --output "$fn" --options manifest
        rm -v $diskImage
        mkdir -p $out/nix-support
        echo "file ova $fn" >> $out/nix-support/hydra-build-products
      '';

    configFile = pkgs.writeText "configuration.nix"
      ''
        { config, lib, pkgs, ... }:
        let

        in {
          imports = [ <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix> ];

          ## Add your changes below
          users.motd = "Restricted Access Only";

          networking.timeServers = [ "10.1.1.101" "10.1.1.102" ];

        }
      '';
  };

  formatAttr = "virtualBoxOVA";
  filename = "*.ova";
}
