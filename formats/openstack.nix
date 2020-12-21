{ modulesPath, config, lib, pkgs, ... }:
if lib.pathExists "${toString modulesPath}/../maintainers/scripts/openstack/nova-image.nix" then {
  imports = [
    "${toString modulesPath}/../maintainers/scripts/openstack/nova-image.nix"
  ];

  formatAttr = "novaImage";
} else {
  imports = [
    "${toString modulesPath}/../maintainers/scripts/openstack/openstack-image.nix"
  ];

  system.build.openstackImage = import "${toString modulesPath}/../lib/make-disk-image.nix" {
    inherit lib config;
    pkgs = import "${toString modulesPath}/../.." { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package
    diskSize = 8192;
    format = "qcow2";
    configFile = pkgs.writeText "configuration.nix"
      ''
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
          ## Add your changes below

        }
      '';
  };

  formatAttr = "openstackImage";
}
