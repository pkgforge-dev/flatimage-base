#!/usr/bin/env bash
#
##DO NOT RUN DIRECTLY
##Self: bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/debian_bootstrap.sh")
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
       sudo unlink "${ROOTFS_DIR}/var/lib/dbus/machine-id" 2>/dev/null
       sudo unlink "${ROOTFS_DIR}/etc/machine-id" 2>/dev/null
       sudo rm -rvf "${ROOTFS_DIR}/etc/machine-id"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'systemd-machine-id-setup --print 2>/dev/null' | sudo tee "${ROOTFS_DIR}/var/lib/dbus/machine-id"
       sudo ln --symbolic --force --relative "${ROOTFS_DIR}/var/lib/dbus/machine-id" "${ROOTFS_DIR}/etc/machine-id"
       echo "LANG=en_US.UTF-8" | sudo tee "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANG=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LANGUAGE=en_US:en" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.conf"
       echo "en_US.UTF-8 UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/locale.gen"
       echo "LC_ALL=en_US.UTF-8" | sudo tee -a "${ROOTFS_DIR}/etc/environment"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'chown -R _apt:root /var/cache/apt/archives/partial/'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'dpkg-statoverride --remove /usr/bin/crontab'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'DEBIAN_FRONTEND="noninteractive" apt update -y'
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" /bin/sh -c 'DEBIAN_FRONTEND="noninteractive" apt install bash binutils coreutils curl fakeroot git locales sudo wget -y --no-install-recommends --ignore-missing'
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
     "${FIM_TMPDIR}/debian.flatimage" fim-perms add "audio,dbus_user,dbus_system,gpu,home,input,media,network,udev,usb,xorg,wayland"
     "${FIM_TMPDIR}/debian.flatimage" fim-perms list
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