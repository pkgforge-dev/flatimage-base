#!/usr/bin/env bash

#-------------------------------------------------------#
##Get Src
 pushd "$(mktemp -d)" >/dev/null 2>&1
 git clone --filter="blob:none" --depth="1" --quiet "https://github.com/ruanformigoni/flatimage" && cd "./flatimage"
##Set ENV
 FIM_SRCDIR="$(realpath .)" && export FIM_SRCDIR="${FIM_SRCDIR}"
 FIM_VERSION="$(git tag --sort="-v:refname" | head -n 1 | tr -d "[:space:]")" && export FIM_VERSION="${FIM_VERSION}"
 if [[ -z "${FIM_VERSION}" ]]; then
   FIM_VERSION="$(git log --oneline --format="%h" | head -n 1 | tr -d "[:space:]")" && export FIM_VERSION="${FIM_VERSION}"
 fi
 export FIM_BINDIR="${FIM_SRCDIR}/FLATIMAGE_BINS" && mkdir -pv "${FIM_BINDIR}"
 export FIM_TMPDIR="${FIM_SRCDIR}/FLATIMAGE_TMP" && mkdir -pv "${FIM_TMPDIR}"
 export FIM_IMGDIR="${FIM_SRCDIR}/FLATIMAGE_BUILDS" && mkdir -pv "${FIM_IMGDIR}"
 SYSTMP="$(dirname $(mktemp -u))" && export SYSTMP="${SYSTMP}"
 USER_AGENT="$(curl -qfsSL 'https://pub.ajam.dev/repos/Azathothas/Wordlists/Misc/User-Agents/ua_chrome_macos_latest.txt')" && export USER_AGENT="${USER_AGENT}"
#-------------------------------------------------------#

#-------------------------------------------------------#
##Static Bins
 pushd "${FIM_SRCDIR}" >/dev/null 2>&1
 #Fetch
  #Bash
   eget "https://github.com/ruanformigoni/bash-static-musl" --asset "$(uname -m)" --to "${FIM_BINDIR}/bash" 2>/dev/null
   [[ ! -f "${FIM_BINDIR}/bash" || $(stat -c%s "${FIM_BINDIR}/bash") -le 1000 ]] && eget "https://bin.ajam.dev/$(uname -m)/bash" --to "${FIM_BINDIR}/bash"
   [[ ! -f "${FIM_BINDIR}/bash" || $(stat -c%s "${FIM_BINDIR}/bash") -le 1000 ]] && echo -e "\n[-] Failed to download bash\n" && exit 1
  #Bwrap
   eget "https://github.com/ruanformigoni/bubblewrap-musl-static" --asset "$(uname -m)" --to "${FIM_BINDIR}/bwrap" 2>/dev/null
   [[ ! -f "${FIM_BINDIR}/bwrap" || $(stat -c%s "${FIM_BINDIR}/bwrap") -le 1000 ]] && eget "https://bin.ajam.dev/$(uname -m)/bwrap" --to "${FIM_BINDIR}/bwrap"
   [[ ! -f "${FIM_BINDIR}/bwrap" || $(stat -c%s "${FIM_BINDIR}/bwrap") -le 1000 ]] && echo -e "\n[-] Failed to download bwrap\n" && exit 1
  #Busybox
   eget "https://github.com/ruanformigoni/busybox-static-musl" --asset "$(uname -m)" --to "${FIM_BINDIR}/busybox" 2>/dev/null
   [[ ! -f "${FIM_BINDIR}/busybox" || $(stat -c%s "${FIM_BINDIR}/busybox") -le 1000 ]] && eget "https://bin.ajam.dev/$(uname -m)/Baseutils/busybox/busybox" --to "${FIM_BINDIR}/busybox"
   [[ ! -f "${FIM_BINDIR}/busybox" || $(stat -c%s "${FIM_BINDIR}/busybox") -le 1000 ]] && echo -e "\n[-] Failed to download busybox\n" && exit 1
  #ciopfs
   eget "https://github.com/ruanformigoni/ciopfs-static-musl" --asset "$(uname -m)" --to "${FIM_BINDIR}/ciopfs" 2>/dev/null
   [[ ! -f "${FIM_BINDIR}/ciopfs" || $(stat -c%s "${FIM_BINDIR}/ciopfs") -le 1000 ]] && eget "https://bin.ajam.dev/$(uname -m)/ciopfs" --to "${FIM_BINDIR}/ciopfs"
   [[ ! -f "${FIM_BINDIR}/ciopfs" || $(stat -c%s "${FIM_BINDIR}/ciopfs") -le 1000 ]] && echo -e "\n[-] Failed to download ciopfs\n" && exit 1
  #dwarfs: https://github.com/mhx/dwarfs/issues/239
   #curl -qfsSL "https://bin.ajam.dev/$(uname -m)/dwarfs-tools" -o "${FIM_BINDIR}/dwarfs_aio"
   if [ "$(uname  -m)" == "aarch64" ]; then
     eget "https://github.com/Azathothas/dwarfs/releases/download/arm64v8/dwarfs-universal" --to "${FIM_BINDIR}/dwarfs_aio" 2>/dev/null
   elif [ "$(uname  -m)" == "x86_64" ]; then
     eget "https://github.com/Azathothas/dwarfs/releases/download/amd64/dwarfs-universal" --to "${FIM_BINDIR}/dwarfs_aio" 2>/dev/null
   fi
  #lsof
   eget "https://github.com/ruanformigoni/lsof-static-musl" --asset "$(uname -m)" --to "${FIM_BINDIR}/lsof" 2>/dev/null
   [[ ! -f "${FIM_BINDIR}/lsof" || $(stat -c%s "${FIM_BINDIR}/lsof") -le 1000 ]] && eget "https://bin.ajam.dev/$(uname -m)/lsof" --to "${FIM_BINDIR}/lsof"
   [[ ! -f "${FIM_BINDIR}/lsof" || $(stat -c%s "${FIM_BINDIR}/lsof") -le 1000 ]] && echo -e "\n[-] Failed to download lsof\n" && exit 1
  #overlayfs
   eget "https://github.com/ruanformigoni/fuse-overlayfs-static-musl" --asset "$(uname -m)" --to "${FIM_BINDIR}/overlayfs" 2>/dev/null
   [[ ! -f "${FIM_BINDIR}/overlayfs" || $(stat -c%s "${FIM_BINDIR}/overlayfs") -le 1000 ]] && eget "https://bin.ajam.dev/$(uname -m)/fuse-overlayfs" --to "${FIM_BINDIR}/overlayfs"
   [[ ! -f "${FIM_BINDIR}/overlayfs" || $(stat -c%s "${FIM_BINDIR}/overlayfs") -le 1000 ]] && echo -e "\n[-] Failed to download overlayfs\n" && exit 1
  #proot 
   eget "https://github.com/ruanformigoni/proot-static-musl" --asset "$(uname -m)" --to "${FIM_BINDIR}/proot" 2>/dev/null
   [[ ! -f "${FIM_BINDIR}/proot" || $(stat -c%s "${FIM_BINDIR}/proot") -le 1000 ]] && eget "https://bin.ajam.dev/$(uname -m)/proot" --to "${FIM_BINDIR}/proot"
   [[ ! -f "${FIM_BINDIR}/proot" || $(stat -c%s "${FIM_BINDIR}/proot") -le 1000 ]] && echo -e "\n[-] Failed to download proot\n" && exit 1
  #squashfuse
   #eget "https://github.com/ruanformigoni/squashfuse-static-musl" --asset "$(uname -m)" --to "${FIM_BINDIR}/squashfuse" 2>/dev/null
   #[[ ! -f "${FIM_BINDIR}/squashfuse" || $(stat -c%s "${FIM_BINDIR}/squashfuse") -le 1000 ]] && eget "https://bin.ajam.dev/$(uname -m)/squashfuse" --to "${FIM_BINDIR}/squashfuse"
   #[[ ! -f "${FIM_BINDIR}/squashfuse" || $(stat -c%s "${FIM_BINDIR}/squashfuse") -le 1000 ]] && echo -e "\n[-] Failed to download squashfuse\n" && exit 1
 #Perms
   find "${FIM_BINDIR}" -type f -exec chmod +x {} \;
 #Symlinks
   "${FIM_BINDIR}/busybox" --list | xargs -I {} sh -c '[ ! -e FLATIMAGE_BINS/{} ] && ln -vs busybox FLATIMAGE_BINS/{}'
   ln --symbolic --force --verbose "dwarfs_aio" "${FIM_BINDIR}/dwarfs"
   ln --symbolic --force --verbose "dwarfs_aio" "${FIM_BINDIR}/mkdwarfs"
 #UPX
   find "${FIM_BINDIR}" -type f | xargs -I "{}" upx -6 --no-lzma "{}"
 #Sanity
   find "${FIM_BINDIR}" -type f | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
 popd >/dev/null 2>&1
#-------------------------------------------------------#


#-------------------------------------------------------#
##FIM Bins
 pushd "${FIM_SRCDIR}" >/dev/null 2>&1
#Compile and include bwrap-apparmor
  docker build "." -t "flatimage-bwrap-apparmor" -f "${FIM_SRCDIR}/docker/Dockerfile.bwrap_apparmor"
  docker run --rm -v "${FIM_BINDIR}:/fim_bins" "flatimage-bwrap-apparmor" cp -fv "/fim/dist/fim_bwrap_apparmor" "/fim_bins/fim_bwrap_apparmor"
  realpath "${FIM_BINDIR}/fim_bwrap_apparmor" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  #set -x ; [[ ! -f "${FIM_BINDIR}/fim_bwrap_apparmor" || $(stat -c%s "${FIM_BINDIR}/fim_bwrap_apparmor") -le 1000 ]] && exit 1
 #Compile and include janitor
  docker build "." --build-arg "FIM_DIST=DUMMY" --build-arg FIM_SRCDIR="$(pwd)" -t "flatimage-boot" -f "${FIM_SRCDIR}/docker/Dockerfile.boot"
  docker run --rm -v "${FIM_BINDIR}:/fim_bins" flatimage-boot cp -fv "/src/boot/build/Release/boot" "/fim_bins/boot"
  realpath "${FIM_BINDIR}/boot" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  set -x ; [[ ! -f "${FIM_BINDIR}/boot" || $(stat -c%s "${FIM_BINDIR}/boot") -le 1000 ]] && exit 1
  docker run --rm -v "${FIM_BINDIR}:/fim_bins" flatimage-boot cp -fv "/src/boot/janitor" "/fim_bins/janitor"
  realpath "${FIM_BINDIR}/janitor" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  set -x ; [[ ! -f "${FIM_BINDIR}/janitor" || $(stat -c%s "${FIM_BINDIR}/janitor") -le 1000 ]] && exit 1
 #Compile and include portal
  docker build "." -t "flatimage-portal" -f "${FIM_SRCDIR}/docker/Dockerfile.portal"
  docker run --rm -v "${FIM_BINDIR}:/fim_bins" "flatimage-portal" cp -fv "/fim/dist/fim_portal" "/fim_bins/fim_portal"
  realpath "${FIM_BINDIR}/fim_portal" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  set -x ; [[ ! -f "${FIM_BINDIR}/fim_portal" || $(stat -c%s "${FIM_BINDIR}/fim_portal") -le 1000 ]] && exit 1
  docker run --rm -v "${FIM_BINDIR}:/fim_bins" "flatimage-portal" cp -fv "/fim/dist/fim_portal_daemon" "/fim_bins/fim_portal_daemon"
  realpath "${FIM_BINDIR}/fim_portal_daemon" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  set -x ; [[ ! -f "${FIM_BINDIR}/fim_portal_daemon" || $(stat -c%s "${FIM_BINDIR}/fim_portal_daemon") -le 1000 ]] && exit 1
 #Copy Bins
  set +x ; sudo chown -R "$(whoami):$(whoami)" "${FIM_BINDIR}" && chmod -R 755 "${FIM_BINDIR}"
#-------------------------------------------------------#


#-------------------------------------------------------#
##Create FlatImage
 function create_flatimage_base()
 {
  #ENV
   local NAME="$1"
   NAME=$(echo "${NAME}" | tr -dc '[:alnum:]-')
   #Sanity Checks
   if [[ -z "${NAME}" ]]; then
      echo -e "\n[+] Invalid NAME, must contain only alphabetical characters\n"
      exit 1
   fi
   if [[ -z "${FIM_TMPDIR}" ]]; then
      echo -e "\n[+] FIM_TMPDIR is NOT Set\n"
      exit 1
   fi
   if [ ! -d "${FIM_TMPDIR}/${NAME}/fim" ] || [ $(du -s "${FIM_TMPDIR}/${NAME}/fim" | cut -f1) -le 1000 ]; then
      echo -e "\n[+] ${FIM_TMPDIR}/${NAME}/fim is Empty or Broken\n"
      exit 1
   fi
  #Create root filesystem and layers folder
   pushd "$(mktemp -d)" >/dev/null 2>&1
   mkdir -pv "./root"
   rsync -achv --mkpath "${FIM_TMPDIR}/${NAME}/." "./root"
   mkdir -pv "./root/fim/layers"
  #Set permissions
   sudo chown -R "1000:1000" "./root"
   #Create image
   [[ ! -f "./root/fim/static/boot" || $(stat -c%s "./root/fim/static/boot") -le 1000 ]] && exit 1
    #"${FIM_BINDIR}/mksquashfs" "./root" "${FIM_TMPDIR}/${NAME}.img" -comp zstd -Xcompression-level 15
    "${FIM_BINDIR}/mkdwarfs" -i "./root" -o "${FIM_TMPDIR}/${NAME}.img" --force
    chmod +x "${FIM_TMPDIR}/${NAME}.img" && du -sh "${FIM_TMPDIR}/${NAME}.img"
    #Concatenate binary files and filesystem to create fim image
     cp -fv "${FIM_BINDIR}/boot" "${FIM_TMPDIR}/${NAME}.flatimage"
     du -sh "${FIM_TMPDIR}/${NAME}.flatimage"
    #Append binaries
     #THIS NEEDS TO BE IN THE EXACT ORDER: https://github.com/ruanformigoni/flatimage/discussions/34#discussioncomment-10982260
     readarray -d '' binaries < <(find "./root/fim/static/"{bash,busybox,bwrap,ciopfs,dwarfs_aio,fim_portal,fim_portal_daemon,fim_bwrap_apparmor,janitor,lsof,overlayfs,proot} -type f -print0 2>/dev/null)
     for binary in "${binaries[@]}"; do
       hex_size_binary="$(printf "%016x" "$(stat -c %s "${binary}")")"
       #Write binary size
       for byte_index in $(seq 0 7 | sort -r); do
         byte="${hex_size_binary:$(( byte_index * 2)):2}"
         echo -ne "\\x${byte}" >> "${FIM_TMPDIR}/${NAME}.flatimage"
       done
       #Append binary
       cat "${binary}" >> "${FIM_TMPDIR}/${NAME}.flatimage"
     done
     echo -e "\n[+] Appended Static Binaries --> ${FIM_TMPDIR}/${NAME}.flatimage"
     du -sh "${FIM_TMPDIR}/${NAME}.flatimage"
    #Create reserved space, 2MB
     dd if="/dev/zero" of="${FIM_TMPDIR}/${NAME}.flatimage" bs="1" count="2097152" oflag="append" conv="notrunc"
     echo -e "\n[+] Reserved 2097152 Byte (2.00 MB) --> ${FIM_TMPDIR}/${NAME}.flatimage"
     du -sh "${FIM_TMPDIR}/${NAME}.flatimage"
    #Write size of image rightafter
     size_img="$(printf "%016x" "$(stat -c %s "${FIM_TMPDIR}/${NAME}.img")")"
     for byte_index in $(seq 0 7 | sort -r); do
       byte="${size_img:$(( byte_index * 2)):2}"
       echo -ne "\\x${byte}" >> "${FIM_TMPDIR}/${NAME}.flatimage"
     done
     echo -e "\n[+] Wrote Image Size --> ${FIM_TMPDIR}/${NAME}.flatimage"
     du -sh "${FIM_TMPDIR}/${NAME}.flatimage"
    #Write image
     cat "${FIM_TMPDIR}/${NAME}.img" >> "${FIM_TMPDIR}/${NAME}.flatimage"
     echo -e "\n[+] Merged ${FIM_TMPDIR}/${NAME}.img --> ${FIM_TMPDIR}/${NAME}.flatimage"
     realpath "${FIM_TMPDIR}/${NAME}.flatimage" && du -sh "${FIM_TMPDIR}/${NAME}.flatimage"
   sudo rm -rf "$(realpath .)" 2>/dev/null ; popd >/dev/null 2>&1
 }
 export -f create_flatimage_base
#-------------------------------------------------------#

#-------------------------------------------------------#
##Alpine
bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/alpine_bootstrap.sh") || true
#-------------------------------------------------------#

#-------------------------------------------------------#
##ArchLinux
bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/archlinux_bootstrap.sh") || true
#-------------------------------------------------------#

#-------------------------------------------------------#
##ArtixLinux
bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/artixlinux_bootstrap.sh") || true
#-------------------------------------------------------#

#-------------------------------------------------------#
##Blueprint (NO OS)
bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/blueprint_bootstrap.sh") || true
#-------------------------------------------------------#

#-------------------------------------------------------#
##cachyos (V3)
bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/cachyos_bootstrap.sh") || true
#-------------------------------------------------------#

#-------------------------------------------------------#
##Debian (Stable:Slim)
bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/debian_bootstrap.sh") || true
#-------------------------------------------------------#

#-------------------------------------------------------#
##eweOS (nightly): https://github.com/eweOS/docker
bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/eweos_bootstrap.sh") || true
#-------------------------------------------------------#

#-------------------------------------------------------#
##Ubuntu (phusion/baseimage)
bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/ubuntu_bootstrap.sh") || true
#-------------------------------------------------------#

#-------------------------------------------------------#
##Void (GLIBC)
bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/void-glibc_bootstrap.sh") || true
#-------------------------------------------------------#

#-------------------------------------------------------#
##Void (MUSL)
bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/void-musl_bootstrap.sh") || true
#-------------------------------------------------------#

#-------------------------------------------------------#
##Cleanup & Pack
popd >/dev/null 2>&1
rm -rfv "${SYSTMP}/FLATIMAGES" 2>/dev/null ; mkdir -pv "${SYSTMP}/FLATIMAGES"
sudo rsync -achLv "${FIM_IMGDIR}/." "${SYSTMP}/FLATIMAGES"
sudo chown -R "$(whoami):$(whoami)" "${SYSTMP}/FLATIMAGES" && chmod -R 755 "${SYSTMP}/FLATIMAGES"
find "${SYSTMP}/FLATIMAGES" -type f | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
ls -lah "${SYSTMP}/FLATIMAGES"
if [ "${USER}" = "runner" ] || [ "$(whoami)" = "runner" ] && [ -s "/opt/runner/provisioner" ]; then
   echo -e "\n[+] Detected GH Actions... Preserving Logs & Output\n"
   echo -e "\n[+] Delete Manually: sudo rm -rfv ${FIM_SRCDIR}\n"
 else
   echo -e "\n[+] PURGING Logs & Output in 180 Seconds... (Hit Ctrl + C)\n"
   echo -e "\n[+] Delete Manually: sudo rm -rfv ${FIM_SRCDIR}\n" ; sleep 180
   rm -rfv "${FIM_SRCDIR}" 2>/dev/null
fi
#-------------------------------------------------------#