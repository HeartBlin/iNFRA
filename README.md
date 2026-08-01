# iNFRA

##### _Perpetually beta btw_

This is my repo for keeping my NixOS flake in. You should not try to install any of the systems defined here. Nothing in this repo is final, I break things often. Commits are sometimes spurious, bulky or lack good messages. The only thing I'm sure of is that the packages exported would work, however they may or may not get removed at any point. This is to say, look at the nix code, stealing things is encouraged, but don't try to run this.

Even so, YMMV with what's here.

[![Check flake](https://github.com/HeartBlin/iNFRA/actions/workflows/check.yaml/badge.svg)](https://github.com/HeartBlin/iNFRA/actions/workflows/check.yaml)
[![License: MIT OR Unlicense](https://img.shields.io/badge/License-MIT%20%7C%20Unlicense-blue.svg)](UNLICENSE)

#### Dual-licensed under [MIT](LICENSE) or the [UNLICENSE](UNLICENSE).

### Hosts

| Host | Type | CPU | RAM | GPU | Storage | Motherboard |
|---|---|---|---|---|---|---|
| [`Void`](/clients/Void/config.nix) | Laptop | AMD Ryzen 7 4800H | 16 GB DDR4-3200 | RTX 3050 Ti | [1 TB NVMe](/clients/Void/disko.nix) | ROG Strix G513IE |
| [`Reason`](/clients/Reason/config.nix) | Server | AMD Ryzen 5 4600G | 16 GB DDR4-2666 | Radeon Vega | [512 GB NVMe](/clients/Reason/disko.nix) + 512 GB SATA (ZFS) | A520M-HDV |

</details>

### Desktop

It's just lightly modified GNOME.

<img alt="Desktop" src=".github/desktop.png" />

### Credits

Configurations where I got *inspired* from:
[TheMaxMur](https://github.com/TheMaxMur/NixOS-Configuration) |
[fufexan](https://github.com/fufexan/dotfiles) |
[rxyhn](https://github.com/rxyhn/yuki) |
[NotAShelf](https://github.com/NotAShelf/nyx) _<sub>archived</sub>_

Thanks! **^\_\_^**
