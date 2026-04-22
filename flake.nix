{
  description = "Nixpkgs-Personal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ags.url = "github:aylur/ags";
    ags.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowInsecure = true;
        config.allowUnfree = true;
      };
      lib = pkgs.lib;

      entries = lib.filterAttrs (
        name: type: type == "directory" || (type == "regular" && builtins.match ".*\\.nix" name != null)
      ) (builtins.readDir ./packages);

      toPackage =
        name: type:
        if type == "regular" then
          pkgs.callPackage ./packages/${name} { }
        else
          pkgs.callPackage ./packages/${name}/${name}.nix { };

      packageSet = builtins.listToAttrs (
        map (name: {
          name = builtins.replaceStrings [ ".nix" ] [ "" ] name;
          value = toPackage name (entries.${name});
        }) (builtins.attrNames entries)
      );

    in
    {
      packages.x86_64-linux = packageSet;
      legacyPackages.x86_64-linux = pkgs // packageSet;
    };
}
