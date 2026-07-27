---
date: '2026-07-24T08:00:00-04:00'
draft: false
title: 'NixOS on the Acer Revo Build M1-601'
---

I'm no gamer, but I am a digital masochist; so when I got the chance to trade an old gaming console for 3 Acer Revo Build M1-601s, I jumped at the opportunity.

They came with Windows and this just wouldn't do.
I've booted Linux (specifically NixOS) on a wide variety of devices, so I figured there couldn't be too much to these unassuming mini PCs.
I was wrong.

![Krang,Bebop, & Rocksteady](/static/krang-bebop-rocksteady.jpg)

## Booting From a USB
I've codified the steps I use to create the live USBs [here](https://github.com/dandeandean/nixos-config/tree/main/hack/primordial-soup).
Typically this process is dirt simple.
With the Acer Nodes, there were a few gotchas:
- Turning on `F12` boot
- Disabling secure boot

Naturally, in order to disable secure boot, you need to set a supervisor password.
After going through these steps, there was still no USB boot option.

For sanity, I checked my live USB against another machine I had around.
It worked there, so it seemed like a compatibility issue with the USB driver.

After running to the USB store, buying a pack of USBs (2.0 this time), & flashing one again, we could could boot into the NixOS installer.

### Recap
- Hit `F2` and `del` keys at startup to boot into the BIOS menu
- Set a supervisor password under the security tab (don't forget this)
- Set `F12` boot to enabled
- Set secure boot to disabled
- Disable supervisor password (or never forget it)
- Spam `F12` on restart

## Installing NixOS
I always reference the [NixOS Installation Guide](https://nixos.wiki/wiki/NixOS_Installation_Guide) for this process.
During the first step (partitioning the persistent storage), I couldn't help but notice the `emmc` device was not present.
Not great.

After some googling, it seems like we just need to load in the `mmc_block` kernel module.
We can do this with `modprobe`:
```bash
sudo modprobe mmc_block
```
Voila, we see the persistent storage and can proceed with the installation as normal!
Finish the install, restart... And the boot fails. Yikes.

### Back to the BIOS
We were getting the message no boot devices found.
I vaguely remember needing to trust the boot device.

We just need to mark the `efi` file as trusted in BIOS.
In order to do this we need to:
- Set a supervisor password (remember it)
- Turn on secure boot
- Mark the file as trusted (`/EMMC/EFI/NixOs-boot/grubx64.efi` in my case)
- Turn off secure boot
- Unset the supervisor password

After this, we can see NixOS start the boot process!


Smooth sailing from here, right? Wrong.

The boot is stuck mounting the emmc drive.
After some (a lot) of tinkering with the boot parameters, we need the mmc module (and others from the hardware scan) not only in the `initrd.availableKernelModules`, but `initrd.kernelModules` as well.

> nixos-enter was crucial for debugging the bad configuration

The final, working, NixOS configuration used the following kernel modules:
```nix
boot.initrd.availableKernelModules = [ "mmc_core" "mmc_block" "xhci_pci" "usb_storage" "usbhid" "sd_mod" "sdhci" "sdhci_pci" "sdhci_acpi" "rtsx_pci_sdmmc" ];
boot.initrd.kernelModules = [ "mmc_core" "mmc_block" "xhci_pci" "usb_storage" "usbhid" "sd_mod" "sdhci" "sdhci_pci" "sdhci_acpi" "rtsx_pci_sdmmc" ];
```
> probably not all of these kernelModules are needed for a bootable device

After this we're able to boot up just fine.
The final configuration can be found in my [NixOS config repo](https://github.com/dandeandean/nixos-config/tree/main/hosts/clones).

In accordance with the theme of my home lab being TMNT characters these machines will be Krang, Bebop, and Rocksteady.

### Recap
- Load the kernel module: `sudo modprobe mmc_block`
- Mount the `emmc` device
- Setup as normal
  - add the kernel modules for startup
- Restart into BIOS
- Reset password & enable secure boot
- Trust the boot partition (specifically `/EMMC/EFI/NixOs-boot/grubx64.efi` in my case)
- Unset password & disable secure boot

> Note: After a node has been fully powered off for some time, they will reset the
> secure boot settings to default.
> We can use the same steps above to mark the device as trusted again.

### Appendix: People Complaining About the Revo Build M1-601 Online
- [Stack Overflow](https://askubuntu.com/questions/1135878/installing-ubuntu-on-an-emmc-how-can-it-be-so-hard)
- [Acer Community Post](https://community.acer.com/en/discussion/558559/revo-m1601-a-waste-of-money)
- [Acer Revo Build M1-601- Acer's Great Failure...](https://www.youtube.com/watch?v=ENqzYRrvIAY)
