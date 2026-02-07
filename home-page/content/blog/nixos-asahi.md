+++
title = "NixOS on Asahi"
description = "Normal MacBook"
sort_by = "date"
paginate_by = 5
insert_anchor_links = "right"
date = "2026-01-11"
+++


I ran out of space on my 2020 Macbook Pro M1.
I'm not sure what it says about what kind of person I am, but to me that just meant I had to factory reset it.
And if I was factory resetting it, I might as well boot it with Linux.

I spent some time (less than a week) on the [Asahi Fedora Remix](https://asahilinux.org/fedora/).
Before this, I was using [Nix Darwin](https://github.com/nix-darwin/nix-darwin), but Nix isn't available on Fedora.


The folks in the nix community put together some solid documention about booting [NixOS on Apple Silicon](https://github.com/nix-community/nixos-apple-silicon).
I figured it was worth a shot.


# Installation
The only significant change that I made was the initial install.
Since I had already installed Fedora, I figured I could just install NixOS right onto that disk partition.

I built the ISO from scratch, made some configuration changes as per the `nixos-apple-silicon` docs, & installing the OS went sideways...

### Power outage
During the initial install, my machine died.
Forgot to plug it in.
Luckily, all of the changes were already written to disk, so I could just install from the `/etc/nixos/configuration.nix` file after mounting the disk again.
After some time, the install went through fine.

Restart... And nothing :(

## Das U-Boot Purgatory
More specifically, I was stuck in the boot menu.
Naturally, this was caused by me going off-script, installing NixOS over the Fedora install.

Now I've been a Linux enjoyer for while, but I haven't played much with any boot menus.
From what I can tell, however, I needed to point to the new /boot partition I made for NixOS.
Simple enough.

In U boot, we can `printenv`, which tells us everything we need to know.

The docs for the `bootflow` command can be found [here](https://docs.u-boot.org/en/latest/usage/cmd/bootflow.html#bootflow-select)

The `bootcmd` was `bootflow scan -b`.
Hmmm...

With a `bootflow list`, we can see what we're working with:
```
Seq  Method   State   Uclass   Part   Name                       FileName
-------------------------------------------------------------------------------------------
0    efi_mgr  ready   (none)      0   <NULL>
1    efi      ready   nvme        4   nvme@27bccc000.blk#1.boot  /EFI/BOOT/BOOTARG64.EFI
-------------------------------------------------------------------------------------------
```
This looks promising. This issue is, it doesn't mean anything to me.
It seemed clear that the `<Null>` and missing `FileName` were issues.
So I tried booting off of the first bootflow and that did the trick.
```
bootflow select 1
bootflow boot
```

So it seems like we needed to boot the 1st bootflow instead of the 0th.
This aligns with the docs for the `-b` option:
```
-b

    Boot each valid bootflow as it is scanned. Typically only the first bootflow matters, since by then the system boots in the OS and U-Boot is no-longer running. bootflow scan -b is a quick way to boot the first available OS. A valid bootflow is one that made it all the way to the loaded state. Note that if -m is provided as well, booting is delayed until the user selects a bootflow.
```
That means we needed to change the bootcmd to the following:
```
setenv bootcmd "bootflow scan ; bootflow select 1 ; bootflow boot"
```
Then `saveenv`, naturally.

## Attempt II

I also have a 2020 Mac Mini with the M1 chip.
I figured I can't have just one of them on Asahi & the other on MacOS, that'd be cruel.
Also, I already had the bootable USB for NixOS on Asahi.

This time around it was much smoother because there wasn't an existing Fedora partition.

## Configuration
Thanks to the reproducibility of Nix, I was able to reuse the majority of my configuration from the previous host.
The code for this can be found in my [nixos-config](https://github.com/dandeandean/nixos-config) repo.

