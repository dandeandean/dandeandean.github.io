# Agent Guide: dandeandean.github.io

This repository contains the source for a personal static site built with [Hugo](https://gohugo.io).

## Architecture & Structure

- `/content`: Contains Markdown files for the site.
  - `_index.md`: Homepage content.
  - `blog/`: Blog posts.
- `/themes`: Hugo themes (currently using 'congo').
- `/static`, `/layouts`, `/data`, `/assets`: Standard Hugo directories.
- `hugo.toml`: Hugo configuration file.
- `flake.nix`: Nix flake for development environment and builds.

## Essential Commands

The project uses Nix to manage the Hugo environment.

- **Development Server**: `nix run .#serve` (or `nix run`)
- **Build**: `nix build .#default`
- **Create New Post**: `nix develop --command hugo new content blog/my-post.md`

## Conventions & Patterns

- **Front Matter**: Uses TOML format within `+++` delimiters (inherited from Zola, compatible with Hugo).
- **Deployment**: Deployed via GitHub Actions (see `.github/workflows/static-site.yml`) using Nix to build the site.

## Gotchas

- **Multi-Architecture**: The `flake.nix` uses `flake-utils` to support multiple architectures (e.g., `x86_64-linux`, `aarch64-linux`).
- **Theme Management**: Themes are managed as Nix flake inputs. The `flake.nix` automatically symlinks them into the `themes/` directory during builds and when entering the development shell.
- **Nix Build**: The GitHub Action uses `nix build .#default` which produces a `./result` symlink containing the static files.
