{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      # on mac "aarch64-darwin";
      system = builtins.getEnv "NIX_SYSTEM";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          zola
        ];
        shellHook = ''
          echo "Zola version $(zola --version)"
        '';
      };
    };
}
