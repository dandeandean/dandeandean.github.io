---
date: '2026-07-24T08:00:00-04:00'
draft: false
title: 'NixOS on the Acer Revo Build M1-601'
---

I'm no gamer, but I am a digital masochist; so when I got the chance to trade an old gaming console for 3 Acer Revo Build M1-601s, I jumped at the opportunity.

They came with Windows and this just wouldn't do.
I've booted Linux (specifically Nix) on a wide variety of devices, so I figured there couldn't be too much to these unassuming mini PCs.
I was wrong.

![Krang,Bebop, & Rocksteady](../images/krang-bebop-rocksteady.jpg)

## Booting From a USB

I've codified the steps I used to create the live NixOS USB in my [NixOS config repo](https://github.com/dandeandean/nixos-config/tree/main/hack/primordial-soup).

Typically this process is dirt simple.
With the Acer Nodes, there were a few gotchas:
- Turn on `F12` boot
- Disable secure boot

Naturally, in order to disable secure boot, you need to set a Supervisor password.
On a fresh startup, still no USB boot option.

For sanity, I checked my live USB against another machine I had around.
It worked there, so it seemed like a compatibility issue with the USB driver.

After running to the USB store, buying a pack of USBs (2.0 this time), & flashing one again, we could could boot off the USB.

### Recap
- Spam `F2` and `del` key at startup to boot into the BIOS menu
- Set a Supervisor password under the security tab (don't forget this)
- `F12` boot -> Enabled
- Secure Boot -> Disabled
- Disable Supervisor password (or never forget it)
- Spam `F12` on restart

