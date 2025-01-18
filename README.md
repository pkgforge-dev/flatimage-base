> - [FlatImage](https://github.com/ruanformigoni/flatimage): https://github.com/ruanformigoni/flatimage
> - For: [Soarpkgs](https://github.com/pkgforge/soarpkgs)
> > - Contact: <a href="https://discord.gg/djJUs48Zbu"><img src="https://github.com/user-attachments/assets/5a336d72-6342-4ca5-87a4-aa8a35277e2f" width="18" height="18"><code>PkgForge (<img src="https://github.com/user-attachments/assets/a08a20e6-1795-4ee6-87e6-12a8ab2a7da6" width="18" height="18">) Discord </code></a> `➼` [`https://discord.gg/djJUs48Zbu`](https://discord.gg/djJUs48Zbu)

- #### Download
> - Continuous Releases are available for [`aarch64`](https://github.com/pkgforge/flatimage-base/releases/tag/aarch64) & [`x86_64`](https://github.com/pkgforge/flatimage-base/releases/tag/x86_64)
> > ```bash
> > !#To get os-release & ldd version
> > curl -qfsSL "https://github.com/pkgforge/flatimage-base/releases/download/$(uname -m)/${IMG_NAME}.txt"
> > #Example: curl -qfsSL "https://github.com/pkgforge/flatimage-base/releases/download/$(uname -m)/alpine.txt"
> >
> > !#To Download the image
> > wget -q "https://github.com/pkgforge/flatimage-base/releases/download/$(uname -m)/${IMG_NAME}.flatimage"
> > #Example: wget -q "https://github.com/pkgforge/flatimage-base/releases/download/$(uname -m)/alpine.flatimage"
> > ```
>
> - [Stable/Tagged](https://github.com/pkgforge/flatimage-base/tags) Releases are also available at: https://github.com/pkgforge/flatimage-base/releases
>
> - `NOTE:` Flatimages based on `aarch64` may exhibit unexpected behavior, and not all distributions are supported.
> - `NOTE:` These Base Images are as minimal as possible and have <ins>[all permissions enabled by default](https://flatimage.github.io/docs/cmd/perms/)</ins>. Details: https://flatimage.github.io/docs/cmd/perms/
> - `NOTE:` **Sometimes Files are NOT uploaded to Releases due to GitHub API Error, make sure to check [ARTIFACTS](https://github.com/pkgforge/flatimage-base/actions)**

- #### Status
> - [![🐧🧹 HealthChecks 🖳🗑️](https://github.com/pkgforge/flatimage-base/actions/workflows/healthchecks_housekeeping.yaml/badge.svg)](https://github.com/pkgforge/flatimage-base/actions/workflows/healthchecks_housekeeping.yaml)
> - [![🛍️ Build 📀 (aarch64-Linux) FlatImages 📦📀](https://github.com/pkgforge/flatimage-base/actions/workflows/build_aarch64_Linux.yaml/badge.svg)](https://github.com/pkgforge/flatimage-base/actions/workflows/build_aarch64_Linux.yaml)
> - [![🛍️ Build 📀 (x86_64-Linux) FlatImages 📦📀](https://github.com/pkgforge/flatimage-base/actions/workflows/build_x86_64_Linux.yaml/badge.svg)](https://github.com/pkgforge/flatimage-base/actions/workflows/build_x86_64_Linux.yaml)
