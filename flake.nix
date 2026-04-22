{
  description = "Nixpkgs-Personal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ags.url = "github:aylur/ags";
    ags.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      ags,
    }@inputs:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      system = pkgs.system;
      agsPkgs = ags.packages.${system};
    in
    {
      packages.x86_64-linux = {
        anycubicSlicerNext = pkgs.callPackage ./packages/anycubicSlicerNext.nix { };
        bespoke-synth = pkgs.callPackage ./packages/bespoke-synth/bespoke-synth.nix { };
        chataigne = pkgs.callPackage ./packages/chataigne/chataigne.nix { };
        glfw-minecraft-wayland =
          pkgs.callPackage ./packages/glfw-minecraft-wayland/glfw-minecraft-wayland.nix
            { };
        lulzbot-cura = pkgs.callPackage ./packages/lulzbot-cura.nix { };
        orca-beta = pkgs.callPackage ./packages/orca-beta/orca-beta.nix { };
        proton-vkvr = pkgs.callPackage ./packages/proton-vkvr.nix { };
        receive-midi = pkgs.callPackage ./packages/receive-midi.nix { };
        send-midi = pkgs.callPackage ./packages/send-midi.nix { };
        teamspeak = pkgs.callPackage ./packages/teamspeak.nix { };

        audio-man = pkgs.callPackage ./packages/audio-man/audio-man.nix {
          agsPkg = agsPkgs.default;
          astal4 = agsPkgs.astal4;
          astal3 = agsPkgs.astal3;
        };
      };
    };
}
