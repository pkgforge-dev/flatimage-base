#!/usr/bin/env bash
#
##DO NOT RUN DIRECTLY
##Self: bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/alpine_bootstrap.sh")
#
#-------------------------------------------------------#
set -x
#Sanity Checks
if [ -z "${FIM_SRCDIR}" ] || \
   [ -z "${FIM_BINDIR}" ] || \
   [ -z "${FIM_IMGDIR}" ]; then
 #exit
  echo -e "\n[+] Skipping Builds...\n"
  exit 1
fi
if [ ! -d "${FIM_BINDIR}" ] || [ $(du -s "${FIM_BINDIR}" | cut -f1) -le 1000 ]; then
    echo -e "\n[+] FIM_BINDIR is Empty or Broken\n"
    exit 1
fi
if ! declare -F create_flatimage_base >/dev/null; then
    echo -e "\n[+] create_flatimage_base Function is undefined\n"
    exit 1
fi
set +x
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