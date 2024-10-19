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
   NAME=$(echo "${NAME}" | tr -dc '[:alpha:]')
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
 echo -e "\n[+] Creating Alpine.FlatImage\n"
 #Bootstrap
 pushd "$(mktemp -d)" >/dev/null 2>&1
  curl -qfsSL "https://bin.ajam.dev/$(uname -m)/apk-static" -o "./apk-static" && chmod +x "./apk-static"
  if [[ -f "./apk-static" ]] && [[ $(stat -c%s "./apk-static") -gt 1024 ]]; then
    mkdir -pv "./rootfs" && export ROOTFS_DIR="$(realpath "./rootfs")"
    if [ -n "${ROOTFS_DIR+x}" ] && [[ "${ROOTFS_DIR}" == "/tmp"* ]]; then
       sudo "./apk-static" --arch "$(uname -m)" -X "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/" -U --allow-untrusted --root "${ROOTFS_DIR}" --initdb add "alpine-base"
       #aria2c "https://pub.ajam.dev/utils/alpine-mini-$(uname -m)/rootfs.tar.gz" \
       #--split="16" --max-connection-per-server="16" --min-split-size="1M" \
       #--check-certificate="false" --console-log-level="error" --user-agent="${USER_AGENT}" \
       #--max-tries="10" --retry-wait="5" --connect-timeout="60" --timeout="600" \
       #--download-result="default" --allow-overwrite --out="./ROOTFS.tar.gz" 2>/dev/null
       #bsdtar -x -f "./ROOTFS.tar.gz" -p -C "${ROOTFS_DIR}" 2>/dev/null
       du -sh "${ROOTFS_DIR}"
       sudo chmod 755 "${ROOTFS_DIR}/bin/bbsuid" 2>/dev/null
       echo -e "nameserver 8.8.8.8\nnameserver 2620:0:ccc::2" | sudo tee "${ROOTFS_DIR}/etc/resolv.conf"
       echo -e "nameserver 1.1.1.1\nnameserver 2606:4700:4700::1111" | sudo tee -a "${ROOTFS_DIR}/etc/resolv.conf"
       sudo mkdir -pv "${ROOTFS_DIR}/etc/apk"
       echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" | sudo tee "${ROOTFS_DIR}/etc/apk/repositories"
       echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" | sudo tee -a "${ROOTFS_DIR}/etc/apk/repositories"
       echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" | sudo tee -a "${ROOTFS_DIR}/etc/apk/repositories"
       echo "LANG=en_US.UTF-8" | sudo tee "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANG=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANGUAGE=en_US:en" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       find "${ROOTFS_DIR}/bin" -type l -lname '/bin/busybox' -exec sudo sh -c 'ln -sf "../bin/busybox" "$1"' _ {} \;
       find "${ROOTFS_DIR}/usr/bin" -type l -lname '/bin/busybox' -exec sudo sh -c 'ln -sf "../../bin/busybox" "$1"' _ {} \;
       find "${ROOTFS_DIR}/bin" "${ROOTFS_DIR}/usr/bin" -type l -exec sudo sh -c 'echo "{} -> $(readlink "{}")"' \;
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'apk update --no-interactive'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'apk upgrade --no-interactive'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'apk add bash curl fakeroot wget --latest --upgrade --no-interactive'
       #sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'apk add bash alsa-utils alsa-utils-doc alsa-lib alsaconf alsa-ucm-conf pulseaudio pulseaudio-alsa --latest --upgrade --no-interactive'
       sudo rm -rfv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run}
       sudo mkdir -pv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run/media,mnt,media,home}
       sudo rm -fv "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       sudo touch "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'apk info -L'
       sudo rm -rfv "${ROOTFS_DIR}/var/cache/apk/"*
       du -sh "${ROOTFS_DIR}"
    fi
  fi
 #Setup FS
  if [ -d "${ROOTFS_DIR}" ] && [ $(du -s "${ROOTFS_DIR}" | cut -f1) -gt 10000 ]; then
    popd >/dev/null 2>&1 ; pushd "${FIM_SRCDIR}" >/dev/null 2>&1
     rm -rfv "${FIM_TMPDIR}/alpine" 2>/dev/null
     mkdir -pv "${FIM_TMPDIR}/alpine/fim/config"
     mkdir -pv "${FIM_TMPDIR}/alpine/fim/static"
     sudo rsync -achv --mkpath "${ROOTFS_DIR}/." "${FIM_TMPDIR}/alpine"
     sudo chown -R "$(whoami):$(whoami)" "${FIM_TMPDIR}/alpine" && chmod -R 755 "${FIM_TMPDIR}/alpine"
    #Copy Bins 
     rsync -achv --mkpath "${FIM_BINDIR}/." "${FIM_TMPDIR}/alpine/fim/static"
    #Copy Desktop, Icon & AppStream
     mkdir -pv "${FIM_TMPDIR}/alpine/fim/desktop"
     cp -fv "${FIM_SRCDIR}/mime/icon.svg" "${FIM_TMPDIR}/alpine/fim/desktop/icon.svg"
     cp -fv "${FIM_SRCDIR}/mime/flatimage.xml" "${FIM_TMPDIR}/alpine/fim/desktop/flatimage.xml"
    #Create
     create_flatimage_base alpine || true
    #Info
     "${FIM_TMPDIR}/alpine.flatimage" fim-env add 'FIM_DIST=alpine' 2>/dev/null
     "${FIM_TMPDIR}/alpine.flatimage" fim-env list 2>/dev/null
     "${FIM_TMPDIR}/alpine.flatimage" fim-commit
  fi
  unset ROOTFS_DIR
 #Copy
  if [[ -f "${FIM_TMPDIR}/alpine.flatimage" ]] && [[ $(stat -c%s "${FIM_TMPDIR}/alpine.flatimage") -gt 10000 ]]; then
     rsync -achLv "${FIM_TMPDIR}/alpine.flatimage" "${FIM_IMGDIR}"
     realpath "${FIM_IMGDIR}/alpine.flatimage" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  fi
 popd >/dev/null 2>&1
#-------------------------------------------------------#


#-------------------------------------------------------#
##ArchLinux
 echo -e "\n[+] Creating ArchLinux.FlatImage\n"
 #Bootstrap
 pushd "$(mktemp -d)" >/dev/null 2>&1
  #docker stop "archlinux" 2>/dev/null ; docker rm "archlinux" 2>/dev/null
  #docker run --name "archlinux" --privileged "azathothas/archlinux:latest" sh -c "hostname 2>/dev/null; cat "/etc/os-release" 2>/dev/null" && docker export "$(docker ps -aqf 'name=archlinux')" --output "rootfs.tar"
  if [ "$(uname  -m)" == "x86_64" ]; then
    aria2c "https://pub.ajam.dev/utils/archlinux-$(uname -m)/rootfs.tar.zst" \
    --split="16" --max-connection-per-server="16" --min-split-size="1M" \
    --check-certificate="false" --console-log-level="error" --user-agent="${USER_AGENT}" \
    --max-tries="10" --retry-wait="5" --connect-timeout="60" --timeout="600" \
    --download-result="default" --allow-overwrite --out="./ROOTFS.tar.zst" 2>/dev/null
    mkdir -pv "./rootfs" && export ROOTFS_DIR="$(realpath "./rootfs")"
    bsdtar -x -f "./ROOTFS.tar.zst" -C "${ROOTFS_DIR}" --strip-components=1 2>/dev/null
   elif [ "$(uname  -m)" == "aarch64" ]; then
    aria2c "https://pub.ajam.dev/utils/archlinuxarm-$(uname -m)/rootfs.tar.gz" \
    --split="16" --max-connection-per-server="16" --min-split-size="1M" \
    --check-certificate="false" --console-log-level="error" --user-agent="${USER_AGENT}" \
    --max-tries="10" --retry-wait="5" --connect-timeout="60" --timeout="600" \
    --download-result="default" --allow-overwrite --out="./ROOTFS.tar.gz" 2>/dev/null
    mkdir -pv "./rootfs" && export ROOTFS_DIR="$(realpath "./rootfs")"
    bsdtar -x -f "./ROOTFS.tar.gz" -C "${ROOTFS_DIR}" --strip-components=1 2>/dev/null
   fi
  if [ -d "${ROOTFS_DIR}" ] && [ $(du -s "${ROOTFS_DIR}" | cut -f1) -gt 10000 ]; then
    if [ -n "${ROOTFS_DIR+x}" ] && [[ "${ROOTFS_DIR}" == "/tmp"* ]]; then
       bsdtar -x -f "./rootfs.tar" -C "${ROOTFS_DIR}" 2>/dev/null
       du -sh "${ROOTFS_DIR}"
       wget "https://bin.ajam.dev/$(uname -m)/rate-mirrors" -O "./rate-mirrors" && chmod +x "./rate-mirrors"
       if [ "$(uname  -m)" == "aarch64" ]; then
         "./rate-mirrors" --allow-root --disable-comments-in-file --save "./mirrors.txt" archarm
       elif [ "$(uname  -m)" == "x86_64" ]; then
         "./rate-mirrors" --allow-root --disable-comments-in-file --save "./mirrors.txt" arch
       fi
       cat "./mirrors.txt" | sudo tee "${ROOTFS_DIR}/etc/pacman.d/mirrorlist"
       sudo rm -rfv "${ROOTFS_DIR}/var/lib/pacman/sync/"*
       sudo rm -rfv "${ROOTFS_DIR}/etc/pacman.d/gnupg/"*
       sudo sed '/DownloadUser/d' -i "${ROOTFS_DIR}/etc/pacman.conf"
       #sudo sed 's/^.*Architecture\s*=.*$/Architecture = auto/' -i "${ROOTFS_DIR}/etc/pacman.conf"
       sudo sed '0,/^.*SigLevel\s*=.*/s//SigLevel = Never/' -i "${ROOTFS_DIR}/etc/pacman.conf"
       #sudo sed 's/^.*SigLevel\s*=.*$/SigLevel = Never/' -i "${ROOTFS_DIR}/etc/pacman.conf"
       sudo sed '/#\[multilib\]/,/#Include = .*/s/^#//' -i "${ROOTFS_DIR}/etc/pacman.conf"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Scc --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Syyu archlinux-keyring pacutils --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman-key --init'
       echo "disable-scdaemon" | sudo tee "/etc/pacman.d/gnupg/gpg-agent.conf"
       #timeout 30s sudo chroot "${ROOTFS_DIR}" "/bin/bash" -c 'pacman-key --populate archlinux'
       timeout 30s sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman-key --populate archlinux'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -y --sync --refresh --refresh --sysupgrade --noconfirm --debug'
       sudo curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks-Extras/refs/heads/main/.github/assets/misc/archlinux_hooks.sh" -o "${ROOTFS_DIR}/arch_hooks.sh"
       sudo chmod +x "${ROOTFS_DIR}/arch_hooks.sh"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c '"/arch_hooks.sh"'
       sudo rm -rfv "${ROOTFS_DIR}/arch_hooks.sh"
       echo "LANG=en_US.UTF-8" | sudo tee "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANG=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANGUAGE=en_US:en" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "en_US.UTF-8 UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.gen"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/environment"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'locale-gen'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'locale-gen "en_US.UTF-8"'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -y --sync --refresh --refresh --sysupgrade --noconfirm'
       #packages="alsa-lib alsa-plugins alsa-tools alsa-utils binutils fakeroot fakechroot git intel-media-driver lib32-alsa-lib lib32-mesa lib32-alsa-plugins lib32-libpulse libva-intel-driver lib32-libva-intel-driver lib32-libva-mesa-driver lib32-libvdpau lib32-mesa-utils lib32-nvidia-utils lib32-pipewire lib32-pipewire-jack lib32-sdl2 lib32-vulkan-icd-loader lib32-vulkan-intel lib32-vulkan-mesa-layers lib32-vulkan-radeon lib32-libxkbcommon libpulse libusb libva-mesa-driver libva-utils libvdpau libxkbcommon mesa mesa-utils nvidia-prime nvidia-utils pipewire pipewire-alsa pipewire-jack pipewire-pulse sdl2 vulkan-icd-loader vulkan-intel vulkan-mesa-layers vulkan-radeon vulkan-tools wireplumber"
       #for pkg in $packages; do sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c "pacman -Sy "$pkg" --needed --noconfirm" ; done
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Sy bash curl fakeroot wget --needed --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Rsndd base-devel --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Rsndd perl --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Rsndd python --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Scc --noconfirm'
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/gtk-doc/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/man/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/help/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/info/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/doc/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/var/tmp/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/var/lib/pacman/sync/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/var/cache/pacman/pkg/"* 2>/dev/null
       sudo find "${ROOTFS_DIR}/boot" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/dev" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/proc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/run" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/sys" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/tmp" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/include" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib32" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/etc/pacman.d/gnupg" -type f -name "S.*" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/locale" -mindepth 1 -maxdepth 1 ! -regex '.*/\(locale.alias\|en\|en_US\)$' -exec sudo rm -rfv {} + 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/gtk-doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/help" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/info" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/man" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type d -name '__pycache__' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacnew' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacsave' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/var/log" -type f -name '*.log' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run}
       sudo mkdir -pv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run/media,mnt,media,home}
       sudo rm -fv "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       sudo touch "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       du -sh "${ROOTFS_DIR}"
    fi
  fi
 #Setup FS
  if [ -d "${ROOTFS_DIR}" ] && [ $(du -s "${ROOTFS_DIR}" | cut -f1) -gt 10000 ]; then
    popd >/dev/null 2>&1 ; pushd "${FIM_SRCDIR}" >/dev/null 2>&1
     rm -rfv "${FIM_TMPDIR}/archlinux" 2>/dev/null
     mkdir -pv "${FIM_TMPDIR}/archlinux/fim/config"
     mkdir -pv "${FIM_TMPDIR}/archlinux/fim/static"
     sudo rsync -achv --mkpath "${ROOTFS_DIR}/." "${FIM_TMPDIR}/archlinux"
     #sudo ln --symbolic --force --verbose "/usr/share" "${FIM_TMPDIR}/archlinux/usr"
     sudo chown -R "$(whoami):$(whoami)" "${FIM_TMPDIR}/archlinux" && chmod -R 755 "${FIM_TMPDIR}/archlinux"
    #Copy Bins 
     rsync -achv --mkpath "${FIM_BINDIR}/." "${FIM_TMPDIR}/archlinux/fim/static"
    #Copy Desktop, Icon & AppStream
     mkdir -pv "${FIM_TMPDIR}/archlinux/fim/desktop"
     cp -fv "${FIM_SRCDIR}/mime/icon.svg" "${FIM_TMPDIR}/archlinux/fim/desktop/icon.svg"
     cp -fv "${FIM_SRCDIR}/mime/flatimage.xml" "${FIM_TMPDIR}/archlinux/fim/desktop/flatimage.xml"
    #Create
     create_flatimage_base archlinux || true
    #Info
     "${FIM_TMPDIR}/archlinux.flatimage" fim-env add 'FIM_DIST=archlinux' 2>/dev/null
     "${FIM_TMPDIR}/archlinux.flatimage" fim-env list 2>/dev/null
     "${FIM_TMPDIR}/archlinux.flatimage" fim-commit
  fi
  unset ROOTFS_DIR
 #Copy
  if [[ -f "${FIM_TMPDIR}/archlinux.flatimage" ]] && [[ $(stat -c%s "${FIM_TMPDIR}/archlinux.flatimage") -gt 10000 ]]; then
     rsync -achLv "${FIM_TMPDIR}/archlinux.flatimage" "${FIM_IMGDIR}"
     realpath "${FIM_IMGDIR}/archlinux.flatimage" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  fi
 docker rmi "artixlinux/artixlinux:latest" --force
 popd >/dev/null 2>&1
#-------------------------------------------------------#


#-------------------------------------------------------#
##Artix
 echo -e "\n[+] Creating Artix.FlatImage\n"
 #Bootstrap
 pushd "$(mktemp -d)" >/dev/null 2>&1
  docker stop "artixlinux" 2>/dev/null ; docker rm "artixlinux" 2>/dev/null
  docker run --name "artixlinux" --privileged "artixlinux/artixlinux:latest" sh -c "hostname 2>/dev/null; cat "/etc/os-release" 2>/dev/null" && docker export "$(docker ps -aqf 'name=artixlinux')" --output "rootfs.tar"
  if [[ -f "./rootfs.tar" ]] && [[ $(stat -c%s "./rootfs.tar") -gt 10000 ]]; then
    mkdir -pv "./rootfs" && export ROOTFS_DIR="$(realpath "./rootfs")"
    if [ -n "${ROOTFS_DIR+x}" ] && [[ "${ROOTFS_DIR}" == "/tmp"* ]]; then
       bsdtar -x -f "./rootfs.tar" -C "${ROOTFS_DIR}" 2>/dev/null
       du -sh "${ROOTFS_DIR}"
       #wget "https://bin.ajam.dev/$(uname -m)/rate-mirrors" -O "./rate-mirrors" && chmod +x "./rate-mirrors"
       #if [ "$(uname  -m)" == "aarch64" ]; then
       #  "./rate-mirrors" --allow-root --disable-comments-in-file --save "./mirrors.txt" artix
       #elif [ "$(uname  -m)" == "x86_64" ]; then
       #  "./rate-mirrors" --allow-root --disable-comments-in-file --save "./mirrors.txt" artix
       #fi
       #cat "./mirrors.txt" | sudo tee "${ROOTFS_DIR}/etc/pacman.d/mirrorlist"
       sudo rm -rfv "${ROOTFS_DIR}/var/lib/pacman/sync/"*
       sudo rm -rfv "${ROOTFS_DIR}/etc/pacman.d/gnupg/"*
       #sudo sed '/DownloadUser/d' -i "${ROOTFS_DIR}/etc/pacman.conf"
       #sudo sed 's/^.*Architecture\s*=.*$/Architecture = auto/' -i "${ROOTFS_DIR}/etc/pacman.conf"
       sudo sed '0,/^.*SigLevel\s*=.*/s//SigLevel = Never/' -i "${ROOTFS_DIR}/etc/pacman.conf"
       #sudo sed 's/^.*SigLevel\s*=.*$/SigLevel = Never/' -i "${ROOTFS_DIR}/etc/pacman.conf"
       sudo sed '/#\[multilib\]/,/#Include = .*/s/^#//' -i "${ROOTFS_DIR}/etc/pacman.conf"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Scc --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Syy artix-keyring archlinux-keyring pacutils --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman-key --init'
       echo "disable-scdaemon" | sudo tee "/etc/pacman.d/gnupg/gpg-agent.conf"
       #timeout 30s sudo chroot "${ROOTFS_DIR}" "/bin/bash" -c 'pacman-key --populate artix archlinux'
       timeout 30s sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman-key --populate artix archlinux'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -y --sync --refresh --refresh --sysupgrade --noconfirm --debug'
       sudo curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks-Extras/refs/heads/main/.github/assets/misc/archlinux_hooks.sh" -o "${ROOTFS_DIR}/arch_hooks.sh"
       sudo chmod +x "${ROOTFS_DIR}/arch_hooks.sh"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c '"/arch_hooks.sh"'
       sudo rm -rfv "${ROOTFS_DIR}/arch_hooks.sh"
       echo "LANG=en_US.UTF-8" | sudo tee "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANG=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANGUAGE=en_US:en" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "en_US.UTF-8 UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.gen"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/environment"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'locale-gen'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'locale-gen "en_US.UTF-8"'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -y --sync --refresh --refresh --sysupgrade --noconfirm'
       #packages="alsa-lib alsa-plugins alsa-tools alsa-utils binutils fakeroot fakechroot git intel-media-driver lib32-alsa-lib lib32-mesa lib32-alsa-plugins lib32-libpulse libva-intel-driver lib32-libva-intel-driver lib32-libva-mesa-driver lib32-libvdpau lib32-mesa-utils lib32-nvidia-utils lib32-pipewire lib32-pipewire-jack lib32-sdl2 lib32-vulkan-icd-loader lib32-vulkan-intel lib32-vulkan-mesa-layers lib32-vulkan-radeon lib32-libxkbcommon libpulse libusb libva-mesa-driver libva-utils libvdpau libxkbcommon mesa mesa-utils nvidia-prime nvidia-utils pipewire pipewire-alsa pipewire-jack pipewire-pulse sdl2 vulkan-icd-loader vulkan-intel vulkan-mesa-layers vulkan-radeon vulkan-tools wireplumber"
       #for pkg in $packages; do sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c "pacman -Sy "$pkg" --needed --noconfirm" ; done
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Sy bash curl fakeroot wget --needed --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Rsndd base-devel --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Rsndd perl --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Rsndd python --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Scc --noconfirm'
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/gtk-doc/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/man/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/help/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/info/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/doc/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/var/tmp/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/var/lib/pacman/sync/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/var/cache/pacman/pkg/"* 2>/dev/null
       sudo find "${ROOTFS_DIR}/boot" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/dev" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/proc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/run" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/sys" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/tmp" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/include" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib32" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/etc/pacman.d/gnupg" -type f -name "S.*" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/locale" -mindepth 1 -maxdepth 1 ! -regex '.*/\(locale.alias\|en\|en_US\)$' -exec sudo rm -rfv {} + 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/gtk-doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/help" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/info" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/man" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type d -name '__pycache__' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacnew' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacsave' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/var/log" -type f -name '*.log' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run}
       sudo mkdir -pv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run/media,mnt,media,home}
       sudo rm -fv "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       sudo touch "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       du -sh "${ROOTFS_DIR}"
    fi
  fi
 #Setup FS
  if [ -d "${ROOTFS_DIR}" ] && [ $(du -s "${ROOTFS_DIR}" | cut -f1) -gt 10000 ]; then
    popd >/dev/null 2>&1 ; pushd "${FIM_SRCDIR}" >/dev/null 2>&1
     rm -rfv "${FIM_TMPDIR}/artix" 2>/dev/null
     mkdir -pv "${FIM_TMPDIR}/artix/fim/config"
     mkdir -pv "${FIM_TMPDIR}/artix/fim/static"
     sudo rsync -achv --mkpath "${ROOTFS_DIR}/." "${FIM_TMPDIR}/artix"
     sudo chown -R "$(whoami):$(whoami)" "${FIM_TMPDIR}/artix" && chmod -R 755 "${FIM_TMPDIR}/artix"
    #Copy Bins 
     rsync -achv --mkpath "${FIM_BINDIR}/." "${FIM_TMPDIR}/artix/fim/static"
    #Copy Desktop, Icon & AppStream
     mkdir -pv "${FIM_TMPDIR}/artix/fim/desktop"
     cp -fv "${FIM_SRCDIR}/mime/icon.svg" "${FIM_TMPDIR}/artix/fim/desktop/icon.svg"
     cp -fv "${FIM_SRCDIR}/mime/flatimage.xml" "${FIM_TMPDIR}/artix/fim/desktop/flatimage.xml"
    #Create
     create_flatimage_base artix || true
    #Info
     "${FIM_TMPDIR}/artix.flatimage" fim-env add 'FIM_DIST=artix' 2>/dev/null
     "${FIM_TMPDIR}/artix.flatimage" fim-env list 2>/dev/null
     "${FIM_TMPDIR}/artix.flatimage" fim-commit
  fi
  unset ROOTFS_DIR
 #Copy
  if [[ -f "${FIM_TMPDIR}/artix.flatimage" ]] && [[ $(stat -c%s "${FIM_TMPDIR}/artix.flatimage") -gt 10000 ]]; then
     rsync -achLv "${FIM_TMPDIR}/artix.flatimage" "${FIM_IMGDIR}"
     realpath "${FIM_IMGDIR}/artix.flatimage" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  fi
 docker rmi "artixlinux/artixlinux:latest" --force
 popd >/dev/null 2>&1
#-------------------------------------------------------#


#-------------------------------------------------------#
##BluePrint
 pushd "${FIM_SRCDIR}" >/dev/null 2>&1
 echo -e "\n[+] Creating Blueprint.FlatImage\n"
 #Setup FS
  rm -rfv "${FIM_TMPDIR}/blueprint/fim" 2>/dev/null
  mkdir -pv "${FIM_TMPDIR}/blueprint/fim/config"
  mkdir -pv "${FIM_TMPDIR}/blueprint/fim/static"
 #Copy Bins 
  rsync -achv --mkpath "${FIM_BINDIR}/." "${FIM_TMPDIR}/blueprint/fim/static"
 #Copy Desktop, Icon & AppStream
  mkdir -pv "${FIM_TMPDIR}/blueprint/fim/desktop"
  cp -fv "${FIM_SRCDIR}/mime/icon.svg" "${FIM_TMPDIR}/blueprint/fim/desktop/icon.svg"
  cp -fv "${FIM_SRCDIR}/mime/flatimage.xml" "${FIM_TMPDIR}/blueprint/fim/desktop/flatimage.xml"
 #Create
  create_flatimage_base blueprint || true
 #Info
  "${FIM_TMPDIR}/blueprint.flatimage" fim-env add 'FIM_DIST=blueprint' 2>/dev/null
  "${FIM_TMPDIR}/blueprint.flatimage" fim-env list 2>/dev/null
  "${FIM_TMPDIR}/blueprint.flatimage" fim-commit
 #Copy
  if [[ -f "${FIM_TMPDIR}/blueprint.flatimage" ]] && [[ $(stat -c%s "${FIM_TMPDIR}/blueprint.flatimage") -gt 10000 ]]; then
     rsync -achLv "${FIM_TMPDIR}/blueprint.flatimage" "${FIM_IMGDIR}"
     realpath "${FIM_IMGDIR}/blueprint.flatimage" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  fi
 popd >/dev/null 2>&1
#-------------------------------------------------------#


#-------------------------------------------------------#
##CachyOS
 echo -e "\n[+] Creating CachyOS.FlatImage\n"
 #Bootstrap
 pushd "$(mktemp -d)" >/dev/null 2>&1
  docker stop "cachyos" 2>/dev/null ; docker rm "cachyos" 2>/dev/null
  docker run --name "cachyos" --privileged "cachyos/cachyos-v3:latest" sh -c "hostname 2>/dev/null; cat "/etc/os-release" 2>/dev/null" && docker export "$(docker ps -aqf 'name=cachyos')" --output "rootfs.tar"
  if [[ -f "./rootfs.tar" ]] && [[ $(stat -c%s "./rootfs.tar") -gt 10000 ]]; then
    mkdir -pv "./rootfs" && export ROOTFS_DIR="$(realpath "./rootfs")"
    if [ -n "${ROOTFS_DIR+x}" ] && [[ "${ROOTFS_DIR}" == "/tmp"* ]]; then
       bsdtar -x -f "./rootfs.tar" -C "${ROOTFS_DIR}" 2>/dev/null
       du -sh "${ROOTFS_DIR}"
       #wget "https://bin.ajam.dev/$(uname -m)/rate-mirrors" -O "./rate-mirrors" && chmod +x "./rate-mirrors"
       #if [ "$(uname  -m)" == "aarch64" ]; then
       #  "./rate-mirrors" --allow-root --disable-comments-in-file --save "./mirrors.txt" cachyos
       #elif [ "$(uname  -m)" == "x86_64" ]; then
       #  "./rate-mirrors" --allow-root --disable-comments-in-file --save "./mirrors.txt" cachyos
       #fi
       #cat "./mirrors.txt" | sudo tee "${ROOTFS_DIR}/etc/pacman.d/mirrorlist"
       sudo rm -rfv "${ROOTFS_DIR}/var/lib/pacman/sync/"*
       sudo rm -rfv "${ROOTFS_DIR}/etc/pacman.d/gnupg/"*
       #sudo sed '/DownloadUser/d' -i "${ROOTFS_DIR}/etc/pacman.conf"
       #sudo sed 's/^.*Architecture\s*=.*$/Architecture = auto/' -i "${ROOTFS_DIR}/etc/pacman.conf"
       sudo sed '0,/^.*SigLevel\s*=.*/s//SigLevel = Never/' -i "${ROOTFS_DIR}/etc/pacman.conf"
       #sudo sed 's/^.*SigLevel\s*=.*$/SigLevel = Never/' -i "${ROOTFS_DIR}/etc/pacman.conf"
       sudo sed '/#\[multilib\]/,/#Include = .*/s/^#//' -i "${ROOTFS_DIR}/etc/pacman.conf"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Scc --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Syyu archlinux-keyring pacutils --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman-key --init'
       echo "disable-scdaemon" | sudo tee "/etc/pacman.d/gnupg/gpg-agent.conf"
       #timeout 30s sudo chroot "${ROOTFS_DIR}" "/bin/bash" -c 'pacman-key --populate cachyos archlinux'
       timeout 30s sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman-key --populate'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -y --sync --refresh --refresh --sysupgrade --noconfirm --debug'
       sudo curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks-Extras/refs/heads/main/.github/assets/misc/archlinux_hooks.sh" -o "${ROOTFS_DIR}/arch_hooks.sh"
       sudo chmod +x "${ROOTFS_DIR}/arch_hooks.sh"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c '"/arch_hooks.sh"'
       sudo rm -rfv "${ROOTFS_DIR}/arch_hooks.sh"
       echo "LANG=en_US.UTF-8" | sudo tee "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANG=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANGUAGE=en_US:en" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "en_US.UTF-8 UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.gen"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/environment"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'locale-gen'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'locale-gen "en_US.UTF-8"'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -y --sync --refresh --refresh --sysupgrade --noconfirm'
       #packages="alsa-lib alsa-plugins alsa-tools alsa-utils binutils fakeroot fakechroot git intel-media-driver lib32-alsa-lib lib32-mesa lib32-alsa-plugins lib32-libpulse libva-intel-driver lib32-libva-intel-driver lib32-libva-mesa-driver lib32-libvdpau lib32-mesa-utils lib32-nvidia-utils lib32-pipewire lib32-pipewire-jack lib32-sdl2 lib32-vulkan-icd-loader lib32-vulkan-intel lib32-vulkan-mesa-layers lib32-vulkan-radeon lib32-libxkbcommon libpulse libusb libva-mesa-driver libva-utils libvdpau libxkbcommon mesa mesa-utils nvidia-prime nvidia-utils pipewire pipewire-alsa pipewire-jack pipewire-pulse sdl2 vulkan-icd-loader vulkan-intel vulkan-mesa-layers vulkan-radeon vulkan-tools wireplumber"
       #for pkg in $packages; do sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c "pacman -Sy "$pkg" --needed --noconfirm" ; done
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Sy bash curl fakeroot wget --needed --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Rsndd base-devel --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Rsndd perl --noconfirm'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Rsndd python --noconfirm'       
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -Scc --noconfirm'
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/gtk-doc/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/man/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/help/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/info/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/usr/share/doc/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/var/tmp/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/var/lib/pacman/sync/"* 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/var/cache/pacman/pkg/"* 2>/dev/null
       sudo find "${ROOTFS_DIR}/boot" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/dev" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/proc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/run" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/sys" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/tmp" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/include" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib32" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/etc/pacman.d/gnupg" -type f -name "S.*" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/locale" -mindepth 1 -maxdepth 1 ! -regex '.*/\(locale.alias\|en\|en_US\)$' -exec sudo rm -rfv {} + 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/gtk-doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/help" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/info" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/man" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type d -name '__pycache__' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacnew' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacsave' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/var/log" -type f -name '*.log' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run}
       sudo mkdir -pv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run/media,mnt,media,home}
       sudo rm -fv "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       sudo touch "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       du -sh "${ROOTFS_DIR}"
    fi
  fi
 #Setup FS
  if [ -d "${ROOTFS_DIR}" ] && [ $(du -s "${ROOTFS_DIR}" | cut -f1) -gt 10000 ]; then
    popd >/dev/null 2>&1 ; pushd "${FIM_SRCDIR}" >/dev/null 2>&1
     rm -rfv "${FIM_TMPDIR}/cachyos" 2>/dev/null
     mkdir -pv "${FIM_TMPDIR}/cachyos/fim/config"
     mkdir -pv "${FIM_TMPDIR}/cachyos/fim/static"
     sudo rsync -achv --mkpath "${ROOTFS_DIR}/." "${FIM_TMPDIR}/cachyos"
     sudo chown -R "$(whoami):$(whoami)" "${FIM_TMPDIR}/cachyos" && chmod -R 755 "${FIM_TMPDIR}/cachyos"
    #Copy Bins 
     rsync -achv --mkpath "${FIM_BINDIR}/." "${FIM_TMPDIR}/cachyos/fim/static"
    #Copy Desktop, Icon & AppStream
     mkdir -pv "${FIM_TMPDIR}/cachyos/fim/desktop"
     cp -fv "${FIM_SRCDIR}/mime/icon.svg" "${FIM_TMPDIR}/cachyos/fim/desktop/icon.svg"
     cp -fv "${FIM_SRCDIR}/mime/flatimage.xml" "${FIM_TMPDIR}/cachyos/fim/desktop/flatimage.xml"
    #Create
     create_flatimage_base cachyos || true
    #Info
     "${FIM_TMPDIR}/cachyos.flatimage" fim-env add 'FIM_DIST=cachyos' 2>/dev/null
     "${FIM_TMPDIR}/cachyos.flatimage" fim-env list 2>/dev/null
     "${FIM_TMPDIR}/cachyos.flatimage" fim-commit
  fi
  unset ROOTFS_DIR
 #Copy
  if [[ -f "${FIM_TMPDIR}/cachyos.flatimage" ]] && [[ $(stat -c%s "${FIM_TMPDIR}/cachyos.flatimage") -gt 10000 ]]; then
     rsync -achLv "${FIM_TMPDIR}/cachyos.flatimage" "${FIM_IMGDIR}"
     realpath "${FIM_IMGDIR}/cachyos.flatimage" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  fi
 docker rmi "cachyos/cachyos-v3:latest" --force
 popd >/dev/null 2>&1
#-------------------------------------------------------#


#-------------------------------------------------------#
##Debian (https://hub.docker.com/_/debian)
 echo -e "\n[+] Creating debian.FlatImage\n"
 #Bootstrap
 pushd "$(mktemp -d)" >/dev/null 2>&1
  docker stop "debian-slim" 2>/dev/null ; docker rm "debian-slim" 2>/dev/null
  docker run --name "debian-slim" --privileged "debian:stable-slim" sh -c "hostname 2>/dev/null; cat "/etc/os-release" 2>/dev/null" && docker export "$(docker ps -aqf 'name=debian-slim')" --output "rootfs.tar"
  if [[ -f "./rootfs.tar" ]] && [[ $(stat -c%s "./rootfs.tar") -gt 10000 ]]; then
    mkdir -pv "./rootfs" && export ROOTFS_DIR="$(realpath "./rootfs")"
    if [ -n "${ROOTFS_DIR+x}" ] && [[ "${ROOTFS_DIR}" == "/tmp"* ]]; then
       bsdtar -x -f "./rootfs.tar" -C "${ROOTFS_DIR}" 2>/dev/null
       du -sh "${ROOTFS_DIR}"
       echo -e "nameserver 8.8.8.8\nnameserver 2620:0:ccc::2" | sudo tee "${ROOTFS_DIR}/etc/resolv.conf"
       echo -e "nameserver 1.1.1.1\nnameserver 2606:4700:4700::1111" | sudo tee -a "${ROOTFS_DIR}/etc/resolv.conf"
       echo "LANG=en_US.UTF-8" | sudo tee "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANG=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANGUAGE=en_US:en" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "en_US.UTF-8 UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.gen"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/environment"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'chown -R _apt:root /var/cache/apt/archives/partial/'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'dpkg-statoverride --remove /usr/bin/crontab'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'DEBIAN_FRONTEND="noninteractive" apt update -y'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'DEBIAN_FRONTEND="noninteractive" apt install bash binutils coreutils curl fakeroot git locales wget -y --no-install-recommends --ignore-missing'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'locale-gen "en_US.UTF-8"'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'apt purge locales perl -y ; apt autoremove -y ; apt autoclean -y'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'apt list --installed'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'apt clean -y'
       sudo find "${ROOTFS_DIR}/boot" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/dev" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/proc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/run" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/sys" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/tmp" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/include" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib32" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/locale" -mindepth 1 -maxdepth 1 ! -regex '.*/\(locale.alias\|en\|en_US\)$' -exec sudo rm -rfv {} + 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/gtk-doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/help" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/info" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/man" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type d -name '__pycache__' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacnew' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacsave' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/var/log" -type f -name '*.log' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/var/lib/apt/lists/"*
       sudo rm -rfv "${ROOTFS_DIR}/var/cache/apt/"*
       sudo rm -rfv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run}
       sudo mkdir -pv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run/media,mnt,media,home}
       sudo rm -fv "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       sudo touch "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       du -sh "${ROOTFS_DIR}"
    fi
  fi
 #Setup FS
  if [ -d "${ROOTFS_DIR}" ] && [ $(du -s "${ROOTFS_DIR}" | cut -f1) -gt 10000 ]; then
    popd >/dev/null 2>&1 ; pushd "${FIM_SRCDIR}" >/dev/null 2>&1
     rm -rfv "${FIM_TMPDIR}/debian" 2>/dev/null
     mkdir -pv "${FIM_TMPDIR}/debian/fim/config"
     mkdir -pv "${FIM_TMPDIR}/debian/fim/static"
     sudo rsync -achv --mkpath "${ROOTFS_DIR}/." "${FIM_TMPDIR}/debian"
     sudo chown -R "$(whoami):$(whoami)" "${FIM_TMPDIR}/debian" && chmod -R 755 "${FIM_TMPDIR}/debian"
    #Copy Bins 
     rsync -achv --mkpath "${FIM_BINDIR}/." "${FIM_TMPDIR}/debian/fim/static"
    #Copy Desktop, Icon & AppStream
     mkdir -pv "${FIM_TMPDIR}/debian/fim/desktop"
     cp -fv "${FIM_SRCDIR}/mime/icon.svg" "${FIM_TMPDIR}/debian/fim/desktop/icon.svg"
     cp -fv "${FIM_SRCDIR}/mime/flatimage.xml" "${FIM_TMPDIR}/debian/fim/desktop/flatimage.xml"
    #Create
     create_flatimage_base debian || true
    #Info
     "${FIM_TMPDIR}/debian.flatimage" fim-env add 'FIM_DIST=debian' 2>/dev/null
     "${FIM_TMPDIR}/debian.flatimage" fim-env list 2>/dev/null
     "${FIM_TMPDIR}/debian.flatimage" fim-commit
  fi
  unset ROOTFS_DIR
 #Copy
  if [[ -f "${FIM_TMPDIR}/debian.flatimage" ]] && [[ $(stat -c%s "${FIM_TMPDIR}/debian.flatimage") -gt 10000 ]]; then
     rsync -achLv "${FIM_TMPDIR}/debian.flatimage" "${FIM_IMGDIR}"
     realpath "${FIM_IMGDIR}/debian.flatimage" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  fi
 docker rmi "debian:stable-slim" --force
 popd >/dev/null 2>&1
#-------------------------------------------------------#


#-------------------------------------------------------#
##Ubuntu (phusion/baseimage)
 echo -e "\n[+] Creating Ubuntu.FlatImage\n"
 #Bootstrap
 pushd "$(mktemp -d)" >/dev/null 2>&1
  docker stop "ubuntu-phusion" 2>/dev/null ; docker rm "ubuntu-phusion" 2>/dev/null
  docker run --name "ubuntu-phusion" --privileged "phusion/baseimage:noble-1.0.0" sh -c "hostname 2>/dev/null; cat "/etc/os-release" 2>/dev/null" && docker export "$(docker ps -aqf 'name=ubuntu-phusion')" --output "rootfs.tar"
  if [[ -f "./rootfs.tar" ]] && [[ $(stat -c%s "./rootfs.tar") -gt 10000 ]]; then
    mkdir -pv "./rootfs" && export ROOTFS_DIR="$(realpath "./rootfs")"
    if [ -n "${ROOTFS_DIR+x}" ] && [[ "${ROOTFS_DIR}" == "/tmp"* ]]; then
       bsdtar -x -f "./rootfs.tar" -C "${ROOTFS_DIR}" 2>/dev/null
       du -sh "${ROOTFS_DIR}"
       echo -e "nameserver 8.8.8.8\nnameserver 2620:0:ccc::2" | sudo tee "${ROOTFS_DIR}/etc/resolv.conf"
       echo -e "nameserver 1.1.1.1\nnameserver 2606:4700:4700::1111" | sudo tee -a "${ROOTFS_DIR}/etc/resolv.conf"
       echo "LANG=en_US.UTF-8" | sudo tee "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANG=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANGUAGE=en_US:en" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "en_US.UTF-8 UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.gen"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/environment"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'chown -R _apt:root /var/cache/apt/archives/partial/'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'dpkg-statoverride --remove /usr/bin/crontab'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'DEBIAN_FRONTEND="noninteractive" apt update -y'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'DEBIAN_FRONTEND="noninteractive" apt install bash binutils coreutils curl fakeroot git locales wget -y --no-install-recommends --ignore-missing'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'locale-gen "en_US.UTF-8"'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'apt purge locales perl -y ; apt autoremove -y ; apt autoclean -y'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'apt list --installed'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'apt clean -y'
       sudo find "${ROOTFS_DIR}/boot" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/dev" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/proc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/run" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/sys" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/tmp" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/include" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib32" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/locale" -mindepth 1 -maxdepth 1 ! -regex '.*/\(locale.alias\|en\|en_US\)$' -exec sudo rm -rfv {} + 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/gtk-doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/help" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/info" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/man" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type d -name '__pycache__' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacnew' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacsave' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/var/log" -type f -name '*.log' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/var/lib/apt/lists/"*
       sudo rm -rfv "${ROOTFS_DIR}/var/cache/apt/"*
       sudo rm -rfv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run}
       sudo mkdir -pv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run/media,mnt,media,home}
       sudo rm -fv "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       sudo touch "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       du -sh "${ROOTFS_DIR}"
    fi
  fi
 #Setup FS
  if [ -d "${ROOTFS_DIR}" ] && [ $(du -s "${ROOTFS_DIR}" | cut -f1) -gt 10000 ]; then
    popd >/dev/null 2>&1 ; pushd "${FIM_SRCDIR}" >/dev/null 2>&1
     rm -rfv "${FIM_TMPDIR}/ubuntu" 2>/dev/null
     mkdir -pv "${FIM_TMPDIR}/ubuntu/fim/config"
     mkdir -pv "${FIM_TMPDIR}/ubuntu/fim/static"
     sudo rsync -achv --mkpath "${ROOTFS_DIR}/." "${FIM_TMPDIR}/ubuntu"
     sudo chown -R "$(whoami):$(whoami)" "${FIM_TMPDIR}/ubuntu" && chmod -R 755 "${FIM_TMPDIR}/ubuntu"
    #Copy Bins 
     rsync -achv --mkpath "${FIM_BINDIR}/." "${FIM_TMPDIR}/ubuntu/fim/static"
    #Copy Desktop, Icon & AppStream
     mkdir -pv "${FIM_TMPDIR}/ubuntu/fim/desktop"
     cp -fv "${FIM_SRCDIR}/mime/icon.svg" "${FIM_TMPDIR}/ubuntu/fim/desktop/icon.svg"
     cp -fv "${FIM_SRCDIR}/mime/flatimage.xml" "${FIM_TMPDIR}/ubuntu/fim/desktop/flatimage.xml"
    #Create
     create_flatimage_base ubuntu || true
    #Info
     "${FIM_TMPDIR}/ubuntu.flatimage" fim-env add 'FIM_DIST=ubuntu' 2>/dev/null
     "${FIM_TMPDIR}/ubuntu.flatimage" fim-env list 2>/dev/null
     "${FIM_TMPDIR}/ubuntu.flatimage" fim-commit
  fi
  unset ROOTFS_DIR
 #Copy
  if [[ -f "${FIM_TMPDIR}/ubuntu.flatimage" ]] && [[ $(stat -c%s "${FIM_TMPDIR}/ubuntu.flatimage") -gt 10000 ]]; then
     rsync -achLv "${FIM_TMPDIR}/ubuntu.flatimage" "${FIM_IMGDIR}"
     realpath "${FIM_IMGDIR}/ubuntu.flatimage" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  fi
 docker rmi "phusion/baseimage:noble-1.0.0" --force
 popd >/dev/null 2>&1
#-------------------------------------------------------#


#-------------------------------------------------------#
##Void (glibc)
 echo -e "\n[+] Creating Void-GLIBC.FlatImage\n"
 #Bootstrap
 pushd "$(mktemp -d)" >/dev/null 2>&1
  docker stop "void-glibc" 2>/dev/null ; docker rm "void-glibc" 2>/dev/null
  docker run --name "void-glibc" --privileged "ghcr.io/void-linux/void-glibc:latest" sh -c "hostname 2>/dev/null; cat "/etc/os-release" 2>/dev/null" && docker export "$(docker ps -aqf 'name=void-glibc')" --output "rootfs.tar"
  if [[ -f "./rootfs.tar" ]] && [[ $(stat -c%s "./rootfs.tar") -gt 10000 ]]; then
    mkdir -pv "./rootfs" && export ROOTFS_DIR="$(realpath "./rootfs")"
    if [ -n "${ROOTFS_DIR+x}" ] && [[ "${ROOTFS_DIR}" == "/tmp"* ]]; then
       bsdtar -x -f "./rootfs.tar" -C "${ROOTFS_DIR}" 2>/dev/null
       du -sh "${ROOTFS_DIR}"
       echo -e "nameserver 8.8.8.8\nnameserver 2620:0:ccc::2" | sudo tee "${ROOTFS_DIR}/etc/resolv.conf"
       echo -e "nameserver 1.1.1.1\nnameserver 2606:4700:4700::1111" | sudo tee -a "${ROOTFS_DIR}/etc/resolv.conf"
       echo "LANG=en_US.UTF-8" | sudo tee "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANG=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANGUAGE=en_US:en" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       find "${ROOTFS_DIR}/bin" "${ROOTFS_DIR}/usr/bin" -type l -exec sudo sh -c 'echo "{} -> $(readlink "{}")"' \;
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'xbps-query --list-repos'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'xbps-install --sync --yes'
       #packages="alsa-utils alsa-lib alsa-plugins-pulseaudio alsa-ucm-conf bash binutils curl fakeroot git intel-media-driver intel-video-accel libjack-pipewire libpipewire libpulseaudio libva-intel-driver libusb libxkbcommon libxkbcommon-tools libxkbcommon-x11 MangoHud mesa mesa-nouveau-dri mesa-vaapi mesa-vdpau mesa-vulkan-intel mesa-vulkan-lavapipe nv-codec-headers pipewire pulseaudio SDL2 Vulkan-Tools vulkan-loader wget wireplumber xf86-video-nouveau"
       #for pkg in $packages; do sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c "xbps-install "$pkg" --sync --update --yes" ; done
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'xbps-install bash curl fakeroot wget --sync --update --yes'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'xbps-query --list-pkgs'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'xbps-remove --clean-cache'
       sudo find "${ROOTFS_DIR}/boot" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/dev" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/proc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/run" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/sys" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/tmp" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/include" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib32" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/locale" -mindepth 1 -maxdepth 1 ! -regex '.*/\(locale.alias\|en\|en_US\)$' -exec sudo rm -rfv {} + 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/gtk-doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/help" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/info" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/man" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type d -name '__pycache__' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacnew' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacsave' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/var/log" -type f -name '*.log' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run}
       sudo mkdir -pv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run/media,mnt,media,home}
       sudo rm -fv "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       sudo touch "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf} 
       du -sh "${ROOTFS_DIR}"
    fi
  fi
 #Setup FS
  if [ -d "${ROOTFS_DIR}" ] && [ $(du -s "${ROOTFS_DIR}" | cut -f1) -gt 10000 ]; then
    popd >/dev/null 2>&1 ; pushd "${FIM_SRCDIR}" >/dev/null 2>&1
     rm -rfv "${FIM_TMPDIR}/void-glibc" 2>/dev/null
     mkdir -pv "${FIM_TMPDIR}/void-glibc/fim/config"
     mkdir -pv "${FIM_TMPDIR}/void-glibc/fim/static"
     sudo rsync -achv --mkpath "${ROOTFS_DIR}/." "${FIM_TMPDIR}/void-glibc"
     sudo chown -R "$(whoami):$(whoami)" "${FIM_TMPDIR}/void-glibc" && chmod -R 755 "${FIM_TMPDIR}/void-glibc"
    #Copy Bins 
     rsync -achv --mkpath "${FIM_BINDIR}/." "${FIM_TMPDIR}/void-glibc/fim/static"
    #Copy Desktop, Icon & AppStream
     mkdir -pv "${FIM_TMPDIR}/void-glibc/fim/desktop"
     cp -fv "${FIM_SRCDIR}/mime/icon.svg" "${FIM_TMPDIR}/void-glibc/fim/desktop/icon.svg"
     cp -fv "${FIM_SRCDIR}/mime/flatimage.xml" "${FIM_TMPDIR}/void-glibc/fim/desktop/flatimage.xml"
    #Create
     create_flatimage_base void-glibc || true
    #Info
     "${FIM_TMPDIR}/void-glibc.flatimage" fim-env add 'FIM_DIST=void-glibc' 2>/dev/null
     "${FIM_TMPDIR}/void-glibc.flatimage" fim-env list 2>/dev/null
     "${FIM_TMPDIR}/void-glibc.flatimage" fim-commit
  fi
  unset ROOTFS_DIR
 #Copy
  if [[ -f "${FIM_TMPDIR}/void-glibc.flatimage" ]] && [[ $(stat -c%s "${FIM_TMPDIR}/void-glibc.flatimage") -gt 10000 ]]; then
     rsync -achLv "${FIM_TMPDIR}/void-glibc.flatimage" "${FIM_IMGDIR}"
     realpath "${FIM_IMGDIR}/void-glibc.flatimage" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  fi
 docker rmi "ghcr.io/void-linux/void-glibc:latest" --force
 popd >/dev/null 2>&1
#-------------------------------------------------------#

#-------------------------------------------------------#
##Void (musl)
 echo -e "\n[+] Creating Void-musl.FlatImage\n"
 #Bootstrap
 pushd "$(mktemp -d)" >/dev/null 2>&1
  docker stop "void-musl" 2>/dev/null ; docker rm "void-musl" 2>/dev/null
  docker run --name "void-musl" --privileged "ghcr.io/void-linux/void-musl:latest" sh -c "hostname 2>/dev/null; cat "/etc/os-release" 2>/dev/null" && docker export "$(docker ps -aqf 'name=void-musl')" --output "rootfs.tar"
  if [[ -f "./rootfs.tar" ]] && [[ $(stat -c%s "./rootfs.tar") -gt 10000 ]]; then
    mkdir -pv "./rootfs" && export ROOTFS_DIR="$(realpath "./rootfs")"
    if [ -n "${ROOTFS_DIR+x}" ] && [[ "${ROOTFS_DIR}" == "/tmp"* ]]; then
       bsdtar -x -f "./rootfs.tar" -C "${ROOTFS_DIR}" 2>/dev/null
       du -sh "${ROOTFS_DIR}"
       echo -e "nameserver 8.8.8.8\nnameserver 2620:0:ccc::2" | sudo tee "${ROOTFS_DIR}/etc/resolv.conf"
       echo -e "nameserver 1.1.1.1\nnameserver 2606:4700:4700::1111" | sudo tee -a "${ROOTFS_DIR}/etc/resolv.conf"
       echo "LANG=en_US.UTF-8" | sudo tee "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANG=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANGUAGE=en_US:en" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       find "${ROOTFS_DIR}/bin" "${ROOTFS_DIR}/usr/bin" -type l -exec sudo sh -c 'echo "{} -> $(readlink "{}")"' \;
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'xbps-query --list-repos'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'xbps-install --sync --yes'
       #packages="alsa-utils alsa-lib alsa-plugins-pulseaudio alsa-ucm-conf bash binutils curl fakeroot git intel-media-driver intel-video-accel libjack-pipewire libpipewire libpulseaudio libva-intel-driver libusb libxkbcommon libxkbcommon-tools libxkbcommon-x11 MangoHud mesa mesa-nouveau-dri mesa-vaapi mesa-vdpau mesa-vulkan-intel mesa-vulkan-lavapipe nv-codec-headers pipewire pulseaudio SDL2 Vulkan-Tools vulkan-loader wget wireplumber xf86-video-nouveau"
       #for pkg in $packages; do sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c "xbps-install "$pkg" --sync --update --yes" ; done
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'xbps-install bash curl fakeroot wget --sync --update --yes'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'xbps-query --list-pkgs'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'xbps-remove --clean-cache'
       sudo find "${ROOTFS_DIR}/boot" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/dev" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/proc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/run" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/sys" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/tmp" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/include" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/lib32" -type f -name "*.a" -print -exec sudo rm -rfv {} 2>/dev/null \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/locale" -mindepth 1 -maxdepth 1 ! -regex '.*/\(locale.alias\|en\|en_US\)$' -exec sudo rm -rfv {} + 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/gtk-doc" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/help" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/info" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}/usr/share/man" -mindepth 1 -delete 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type d -name '__pycache__' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacnew' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}" -type f -name '*.pacsave' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo find "${ROOTFS_DIR}/var/log" -type f -name '*.log' -exec sudo rm -rfv {} \; 2>/dev/null
       sudo rm -rfv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run}
       sudo mkdir -pv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run/media,mnt,media,home}
       sudo rm -fv "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf}
       sudo touch "${ROOTFS_DIR}"/etc/{host.conf,hosts,passwd,group,nsswitch.conf} 
       du -sh "${ROOTFS_DIR}"
    fi
  fi
 #Setup FS
  if [ -d "${ROOTFS_DIR}" ] && [ $(du -s "${ROOTFS_DIR}" | cut -f1) -gt 10000 ]; then
    popd >/dev/null 2>&1 ; pushd "${FIM_SRCDIR}" >/dev/null 2>&1
     rm -rfv "${FIM_TMPDIR}/void-musl" 2>/dev/null
     mkdir -pv "${FIM_TMPDIR}/void-musl/fim/config"
     mkdir -pv "${FIM_TMPDIR}/void-musl/fim/static"
     sudo rsync -achv --mkpath "${ROOTFS_DIR}/." "${FIM_TMPDIR}/void-musl"
     sudo chown -R "$(whoami):$(whoami)" "${FIM_TMPDIR}/void-musl" && chmod -R 755 "${FIM_TMPDIR}/void-musl"
    #Copy Bins 
     rsync -achv --mkpath "${FIM_BINDIR}/." "${FIM_TMPDIR}/void-musl/fim/static"
    #Copy Desktop, Icon & AppStream
     mkdir -pv "${FIM_TMPDIR}/void-musl/fim/desktop"
     cp -fv "${FIM_SRCDIR}/mime/icon.svg" "${FIM_TMPDIR}/void-musl/fim/desktop/icon.svg"
     cp -fv "${FIM_SRCDIR}/mime/flatimage.xml" "${FIM_TMPDIR}/void-musl/fim/desktop/flatimage.xml"
    #Create
     create_flatimage_base void-musl || true
    #Info
     "${FIM_TMPDIR}/void-musl.flatimage" fim-env add 'FIM_DIST=void-musl' 2>/dev/null
     "${FIM_TMPDIR}/void-musl.flatimage" fim-env list 2>/dev/null
     "${FIM_TMPDIR}/void-musl.flatimage" fim-commit
  fi
  unset ROOTFS_DIR
 #Copy
  if [[ -f "${FIM_TMPDIR}/void-musl.flatimage" ]] && [[ $(stat -c%s "${FIM_TMPDIR}/void-musl.flatimage") -gt 10000 ]]; then
     rsync -achLv "${FIM_TMPDIR}/void-musl.flatimage" "${FIM_IMGDIR}"
     realpath "${FIM_IMGDIR}/void-musl.flatimage" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  fi
 docker rmi "ghcr.io/void-linux/void-musl:latest" --force
 popd >/dev/null 2>&1
#-------------------------------------------------------#


#-------------------------------------------------------#
##Cleanup & Pack
popd >/dev/null 2>&1
rm -rfv "${SYSTMP}/FLATIMAGES" 2>/dev/null ; mkdir -pv "${SYSTMP}/FLATIMAGES"
sudo rsync -achLv "${FIM_IMGDIR}/." "${SYSTMP}/FLATIMAGES"
sudo chown -R "$(whoami):$(whoami)" "${SYSTMP}/FLATIMAGES" && chmod -R 755 "${SYSTMP}/FLATIMAGES"
find "${SYSTMP}/FLATIMAGES" -type f | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
ls -lah "${SYSTMP}/FLATIMAGES"
echo -e "\n[+] PURGING Logs & Output in 180 Seconds... (Hit Ctrl + C)\n"
echo -e "\n[+] Delete Manually: sudo rm -rfv ${FIM_SRCDIR}\n" ; sleep 180
rm -rfv "${FIM_SRCDIR}" 2>/dev/null
#-------------------------------------------------------#