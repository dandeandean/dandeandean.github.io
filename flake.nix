{
  description = "Hugo personal site";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        serveScript = pkgs.writeShellScriptBin "hugo-serve" ''
          exec ${pkgs.hugo}/bin/hugo server -D
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.hugo
            serveScript
          ];
          shellHook = "";
        };

        packages.default = pkgs.stdenv.mkDerivation {
          name = "dandeandean-github-io";
          src = ./.;
          buildInputs = [ pkgs.hugo ];
          buildPhase = ''
            hugo --minify
          '';
          installPhase = "cp -r public $out";
        };

        apps.serve = {
          type = "app";
          program = "${serveScript}/bin/hugo-serve";
        };

        apps.default = self.apps.${system}.serve;
      }
    );
}
