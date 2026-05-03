{
  description = "Hugo personal site";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    congo = {
      url = "github:jpanther/congo";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      congo,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        serveScript = pkgs.writeShellScriptBin "hugo-serve" ''
          mkdir -p themes
          ln -snf ${congo} themes/congo
          exec ${pkgs.hugo}/bin/hugo server -D
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.hugo
            serveScript
          ];
          shellHook = ''
            mkdir -p themes
            ln -snf ${congo} themes/congo
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          name = "dandeandean-github-io";
          src = ./.;
          buildInputs = [ pkgs.hugo ];
          buildPhase = ''
            mkdir -p themes
            ln -snf ${congo} themes/congo
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
