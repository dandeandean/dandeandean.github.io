{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = builtins.currentSystem;
    in
    {
      packages.${system}.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    };
}
