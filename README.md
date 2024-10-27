> - [FlatImage](https://github.com/ruanformigoni/flatimage): https://github.com/ruanformigoni/flatimage
> - For: [Toolpacks-Extras](https://github.com/Azathothas/Toolpacks-Extras)
> > - Contact: <a href="https://t.me/official_loonix/63949"><img src="https://github.com/user-attachments/assets/2edc90b9-606e-4bfc-89f3-2a758b2f0377" width="18" height="18"><code>Loonix (<img src="https://github.com/user-attachments/assets/abc35eee-c9c9-4023-9035-d440b56cac4c" width="18" height="18">) Telegram</code></a> `➼` [`https://t.me/official_loonix/63949`](https://t.me/official_loonix/63949)

- #### Download
> - Continuous Releases are available for [`aarch64`](https://github.com/Azathothas/flatimage-base/releases/tag/aarch64) & [`x86_64`](https://github.com/Azathothas/flatimage-base/releases/tag/x86_64)
> > ```bash
> > !#To get os-release & ldd version
> > curl -qfsSL "https://github.com/Azathothas/flatimage-base/releases/download/$(uname -m)/${IMG_NAME}.txt"
> > #Example: curl -qfsSL "https://github.com/Azathothas/flatimage-base/releases/download/$(uname -m)/alpine.txt"
> >
> > !#To Download the image
> > wget -q "https://github.com/Azathothas/flatimage-base/releases/download/$(uname -m)/${IMG_NAME}.flatimage"
> > #Example: wget -q "https://github.com/Azathothas/flatimage-base/releases/download/$(uname -m)/alpine.flatimage"
> > ```
>
> - [Stable/Tagged](https://github.com/Azathothas/flatimage-base/tags) Releases are also available at: https://github.com/Azathothas/flatimage-base/releases
>
> - `NOTE:` Flatimages based on `aarch64` may exhibit unexpected behavior, and not all distributions are supported.
> - `NOTE:` These Base Images are as minimal as possible and have <ins>[all permissions enabled by default](https://flatimage.github.io/docs/cmd/perms/)</ins>. Details: https://flatimage.github.io/docs/cmd/perms/
> - `NOTE:` **Sometimes Files are NOT uploaded to Releases due to GitHub API Error, make sure to check [ARTIFACTS](https://github.com/Azathothas/flatimage-base/actions)**

- #### Status
> - [![🐧🧹 HealthChecks 🖳🗑️](https://github.com/Azathothas/flatimage-base/actions/workflows/healthchecks_housekeeping.yaml/badge.svg)](https://github.com/Azathothas/flatimage-base/actions/workflows/healthchecks_housekeeping.yaml)
> - [![🛍️ Build 📀 (aarch64-Linux) FlatImages 📦📀](https://github.com/Azathothas/flatimage-base/actions/workflows/build_aarch64_Linux.yaml/badge.svg)](https://github.com/Azathothas/flatimage-base/actions/workflows/build_aarch64_Linux.yaml)
> - [![🛍️ Build 📀 (x86_64-Linux) FlatImages 📦📀](https://github.com/Azathothas/flatimage-base/actions/workflows/build_x86_64_Linux.yaml/badge.svg)](https://github.com/Azathothas/flatimage-base/actions/workflows/build_x86_64_Linux.yaml)
