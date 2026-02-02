+++
title = "NixOS on Asahi"
description = "Normal MacBook"
sort_by = "date"
paginate_by = 5
insert_anchor_links = "right"
date = "2026-01-11"
+++


I spent some time (less than a week) on the [Asahi Fedora Remix](https://asahilinux.org/fedora/).

After some time using [Nix Darwin](https://github.com/nix-darwin/nix-darwin) on my 2020 Macbook Pro M1, I decided to make the jump to NixOS.
I've had minimal experience with NixOS on a desktop I keep for a rainy day, but using it as my daily driver would be a significant jump.
My desktop had already been a NixOS box, so I was looking to heavily leverage the Nix reproducibility between hosts.

# Installing
The installation directions can be found [Here](https://github.com/nix-community/nixos-apple-silicon).
The only significant change that I made was the initial install.
Since I had already installed Fedora, I figured I could just install NixOS right onto that disk partition.

I built the ISO from scratch, made some configuration changes as per the `nixos-apple-silicon` docs, & installing the OS went sideways...

### Power outage
During the initial install, my machine died.
Forgot to plug it in.
Luckily, all of the changes were already written to disk, so I could just install from the `/etc/nixos/configuration.nix` file after mounting the disk again.
After some time, the install went through fine.

Restart... and nothing :(

## Das U-Boot Purgatory
More specifically, I was stuck in the boot menu.
Naturally, this was caused by me going off-script, installing NixOS over the Fedora install.

Now I've been a Linux enjoyer for while, but I haven't played much with any boot menus.
From what I can tell, however, I needed to point to the new /boot partition I made for NixOS.
Simple enough.

In U boot, we can `printenv`, which tells us everything we need to know.

## Part II


# Configuration
Thanks to the reproducibility of Nix, I was able to reuse the majority of my configuration from the previous host.
