# iNFRA

##### _Perpetually beta btw_

This is my repo for keeping my NixOS flake in. You should not try to install any of the systems defined here. Nothing in this repo is final, I break things often. Commits are sometimes spurious, bulky or lack good messages. The only thing I'm sure of is that the packages exported would work, however they may or may not get removed at any point. This is to say, look at the nix code, stealing things is encouraged, but don't try to run this.

Even so, YMMV with what's here.

[![License: MIT OR Unlicense](https://img.shields.io/badge/License-MIT%20%7C%20Unlicense-blue.svg)](UNLICENSE)
[![Check flake](https://github.com/HeartBlin/iNFRA/actions/workflows/check.yaml/badge.svg)](https://github.com/HeartBlin/iNFRA/actions/workflows/check.yaml)
[![ISO Builds](https://github.com/HeartBlin/iNFRA/actions/workflows/iso.yaml/badge.svg)](https://github.com/HeartBlin/iNFRA/actions/workflows/iso.yaml)

#### Dual-licensed under [MIT](LICENSE) or the [UNLICENSE](UNLICENSE).

### Desktop

It's just lightly modified GNOME.

<img alt="Desktop With Things" src=".github/desktop_without.png" />
<img alt="Desktop Without Things" src=".github/desktop_with.png" />

### Hosts

<details>
<summary><strong><code><a href="/clients/Origin/config.nix">Origin</a></code></strong> <sub><em>install iso</em></sub></summary>

<sub>An ISO doesn't exactly have specs...</sub>

</details>

<details>
<summary><strong><code><a href="/clients/Reason/config.nix">Reason</a></code></strong> <sub><em>server</em></sub></summary>

* **CPU:** AMD Ryzen 5 4600G
* **RAM:** 16 GB DDR4-2666
* **GPU:** Radeon Vega
* **Storage:** [512 GB NVMe](/clients/Reason/disko.nix) (XFS) + 512 GB SATA (ZFS)
* **Motherboard:** A520M-HDV

</details>

<details>
<summary><strong><code><a href="/clients/Void/config.nix">Void</a></code></strong> <sub><em>laptop</em></sub></summary>

* **CPU:** AMD Ryzen 7 4800H
* **RAM:** 16 GB DDR4-3200
* **GPU:** Radeon Vega + RTX 3050Ti
* **Storage:** [1 TB NVMe](/clients/Void/disko.nix) (XFS)
* **Motherboard:** ROG Strix G513IE

</details>

<details>
<summary><strong><code><a href="https://www.gsmarena.com/google_pixel_9a-13478.php">Thunder</a></code></strong> <sub><em>phone</em></sub></summary>

* **CPU:** Google Tensor G4
* **RAM:** 8 GB LPDDR5X
* **GPU:** Mali-G715
* **Storage:** 128 GB (f2fs)
* **Model:** Pixel 9a

</details>

<details>
<summary><strong><code><a href="https://www.gsmarena.com/samsung_galaxy_tab_s9_fe-12517.php">Wind</a></code></strong> <sub><em>tablet</em></sub></summary>

* **CPU:** Exynos 1380
* **RAM:** 8 GB LPDDR4X
* **GPU:** Mali-G68 MP5
* **Storage:** 128 GB (f2fs)
* **Model:** Galaxy Tab S9 FE

</details>

<details>
<summary><strong><code><a href="https://www.gsmarena.com/samsung_galaxy_watch5-11748.php">Ice</a></code></strong> <sub><em>watch</em></sub></summary>

* **CPU:** Exynos W920
* **RAM:** 1.5GB LPDDR4
* **GPU:** Mali-G68
* **Storage:** 16 GB (f2fs)
* **Model:** Galaxy Watch5

</details>

<details>
<summary><strong><code><a href="https://www.ovhcloud.com/en/">Death</a></code></strong> <sub><em>s3</em></sub></summary>

<sub>C'mon, it's a OVH S3!</sub>

</details>

<details>
<summary><strong><code><a href="/clients/Finality/config.nix">Finality</a></code></strong> <sub><em>ca iso</em></sub></summary>

<sub>An ISO still doesn't exactly have specs...</sub>

</details>

### Credits

Configurations where I got *inspired* from:
[TheMaxMur](https://github.com/TheMaxMur/NixOS-Configuration) |
[fufexan](https://github.com/fufexan/dotfiles) |
[rxyhn](https://github.com/rxyhn/yuki) |
[NotAShelf](https://github.com/NotAShelf/nyx) _<sub>archived</sub>_

Thanks! **^\_\_^**
