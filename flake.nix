{
  description = "Hugo personal site";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    papermod = {
      url = "github:adityatelange/hugo-PaperMod";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      papermod,
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
          name = "dan-deandean";
          src = ./.;
          buildInputs = [ pkgs.hugo ];
          buildPhase = ''
            mkdir -p site-hugo/themes
            ln -s ${papermod} site-hugo/themes/PaperMod
            cd site-hugo
            hugo --minify
          '';
          installPhase = ''
            cp -r public $out
          '';
        };

        apps.serve = {
          type = "app";
          program = "${serveScript}/bin/hugo-serve";
        };

        apps.default = self.apps.${system}.serve;
      }
    );
}
