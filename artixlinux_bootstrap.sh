#!/usr/bin/env bash
#
##DO NOT RUN DIRECTLY
##Self: bash <(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/artixlinux_bootstrap.sh")
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
##ArtixLinux
 echo -e "\n[+] Creating ArtixLinux.FlatImage\n"
 #Bootstrap
 pushd "$(mktemp -d)" >/dev/null 2>&1
  docker stop "artixlinux" 2>/dev/null ; docker rm "artixlinux" 2>/dev/null
  docker run --name "artixlinux" --privileged "artixlinux/artixlinux:latest" bash -l -c '
  #Bootstrap
   pacman -y --sync --refresh --refresh --sysupgrade --noconfirm --debug
   packages="bash binutils curl fakechroot fakeroot wget"
   for pkg in $packages; do pacman -Sy "$pkg" --noconfirm ; done
   for pkg in $packages; do pacman -Sy "$pkg" --needed --noconfirm ; done
  #Mirrors 
   #wget "https://bin.ajam.dev/$(uname -m)/rate-mirrors" -O "./rate-mirrors" && chmod +x "./rate-mirrors"
   #if [ "$(uname  -m)" == "aarch64" ]; then
   #  "./rate-mirrors" --allow-root --disable-comments-in-file --save "./mirrors.txt" artix
   #elif [ "$(uname  -m)" == "x86_64" ]; then
   #  "./rate-mirrors" --allow-root --disable-comments-in-file --save "./mirrors.txt" artix
   #fi
   #cat "./mirrors.txt" | tee "/etc/pacman.d/mirrorlist"
  #Fix & Patches 
   sed '\''/DownloadUser/d'\'' -i "/etc/pacman.conf"
   #sed '\''s/^.*Architecture\s*=.*$/Architecture = auto/'\'' -i "/etc/pacman.conf"
   sed '\''0,/^.*SigLevel\s*=.*/s//SigLevel = Never/'\'' -i "/etc/pacman.conf"
   #sed '\''s/^.*SigLevel\s*=.*$/SigLevel = Never/'\'' -i "/etc/pacman.conf"
   sed '\''/#\[multilib\]/,/#Include = .*/s/^#//'\'' -i "/etc/pacman.conf"
   echo -e "nameserver 8.8.8.8\nnameserver 2620:0:ccc::2" | tee "/etc/resolv.conf"
   echo -e "nameserver 1.1.1.1\nnameserver 2606:4700:4700::1111" | tee -a "/etc/resolv.conf"
   unlink "/var/lib/dbus/machine-id" 2>/dev/null
   unlink "/etc/machine-id" 2>/dev/null
   rm -rvf "/etc/machine-id"
   systemd-machine-id-setup --print 2>/dev/null | tee "/var/lib/dbus/machine-id"
   cat "/var/lib/dbus/machine-id" | tee "/etc/machine-id"
   pacman -Scc --noconfirm
   echo "disable-scdaemon" | tee "/etc/pacman.d/gnupg/gpg-agent.conf"
   curl -qfsSL "https://raw.githubusercontent.com/Azathothas/flatimage-base/refs/heads/main/archlinux_hooks.sh" -o "/arch_hooks.sh"
   chmod +x "/arch_hooks.sh" ; "/arch_hooks.sh"
   rm -rfv "/arch_hooks.sh"
   echo "LANG=en_US.UTF-8" | tee "/etc/locale.conf"
   echo "LANG=en_US.UTF-8" | tee -a "/etc/locale.conf"
   echo "LANGUAGE=en_US:en" | tee -a "/etc/locale.conf"
   echo "LC_ALL=en_US.UTF-8" | tee -a "/etc/locale.conf"
   echo "en_US.UTF-8 UTF-8" | tee -a "/etc/locale.gen"
   echo "LC_ALL=en_US.UTF-8" | tee -a "/etc/environment"
   locale-gen ; locale-gen "en_US.UTF-8"
  #Cleanup
   pacman -y --sync --refresh --refresh --sysupgrade --noconfirm
   pacman -Rsn base-devel --noconfirm
   pacman -Rsn perl --noconfirm
   pacman -Rsn python --noconfirm
   pacman -Scc --noconfirm
  #Fake-Sudo
   pacman -Rsndd sudo 2>/dev/null
   rm -rvf "/usr/bin/sudo" 2>/dev/null
   curl -qfsSL "https://github.com/Azathothas/flatimage-base/releases/download/$(uname -m)/fake-sudo-pkexec.tar.zst" -o "./fake-sudo-pkexec.tar.zst" && chmod +x "./fake-sudo-pkexec.tar.zst"
   pacman -Uddd "./fake-sudo-pkexec.tar.zst" --noconfirm
   pacman -Syy fakeroot --needed --noconfirm
   rm -rvf "./fake-sudo-pkexec.tar.zst"
  #Yay
   curl -qfsSL "https://github.com/Azathothas/flatimage-base/releases/download/$(uname -m)/yay" -o "/usr/bin/yay" && chmod +x "/usr/bin/yay"
   yay --version  ; which fakeroot yay sudo
  #More cleanup
   rm -rfv "/usr/share/gtk-doc/"* 2>/dev/null
   rm -rfv "/usr/share/man/"* 2>/dev/null
   rm -rfv "/usr/share/help/"* 2>/dev/null
   rm -rfv "/usr/share/info/"* 2>/dev/null
   rm -rfv "/usr/share/doc/"* 2>/dev/null
   rm -rfv "/var/tmp/"* 2>/dev/null
   rm -rfv "/var/lib/pacman/sync/"* 2>/dev/null
   rm -rfv "/var/cache/pacman/pkg/"* 2>/dev/null
   find "/boot" -mindepth 1 -delete 2>/dev/null
   find "/dev" -mindepth 1 -delete 2>/dev/null
   find "/proc" -mindepth 1 -delete 2>/dev/null
   find "/run" -mindepth 1 -delete 2>/dev/null
   find "/sys" -mindepth 1 -delete 2>/dev/null
   find "/tmp" -mindepth 1 -delete 2>/dev/null
   find "/usr/include" -mindepth 1 -delete 2>/dev/null
   find "/usr/lib" -type f -name "*.a" -print -exec rm -rfv "{}" 2>/dev/null \; 2>/dev/null
   find "/usr/lib32" -type f -name "*.a" -print -exec rm -rfv "{}" 2>/dev/null \; 2>/dev/null
   find "/etc/pacman.d/gnupg" -type f -name "S.*" -print -exec rm -rfv "{}" 2>/dev/null \; 2>/dev/null
   find "/usr/share/locale" -mindepth 1 -maxdepth 1 ! -regex ".*/\(locale.alias\|en\|en_US\)$" -exec rm -rfv "{}" + 2>/dev/null
   find "/usr/share/doc" -mindepth 1 -delete 2>/dev/null
   find "/usr/share/gtk-doc" -mindepth 1 -delete 2>/dev/null
   find "/usr/share/help" -mindepth 1 -delete 2>/dev/null
   find "/usr/share/info" -mindepth 1 -delete 2>/dev/null
   find "/usr/share/man" -mindepth 1 -delete 2>/dev/null
   find "" -type d -name "__pycache__" -exec rm -rfv "{}" \; 2>/dev/null
   find "" -type f -name "*.pacnew" -exec rm -rfv "{}" \; 2>/dev/null
   find "" -type f -name "*.pacsave" -exec rm -rfv "{}" \; 2>/dev/null
   find "/var/log" -type f -name "*.log" -exec rm -rfv "{}" \; 2>/dev/null
   rm -rfv "/"{tmp,proc,sys,dev,run} 2>/dev/null
   mkdir -pv "/"{tmp,proc,sys,dev,run/media,mnt,media,home}  2>/dev/null
   rm -fv ""/etc/{host.conf,hosts,nsswitch.conf}  2>/dev/null
   touch ""/etc/{host.conf,hosts,nsswitch.conf}  2>/dev/null
   hostname 2>/dev/null; cat "/etc/os-release" 2>/dev/null'
   docker export "$(docker ps -aqf 'name=artix')" --output "rootfs.tar"
  if [[ -f "./rootfs.tar" ]] && [[ $(stat -c%s "./rootfs.tar") -gt 10000 ]]; then
    mkdir -pv "./rootfs" && export ROOTFS_DIR="$(realpath "./rootfs")"
    rsync -achLv --mkpath "./rootfs.tar" "/tmp/ROOTFS/artixlinux.rootfs.tar"
    if [ -n "${ROOTFS_DIR+x}" ] && [[ "${ROOTFS_DIR}" == "/tmp"* ]]; then
       bsdtar -x -f "./rootfs.tar" -C "${ROOTFS_DIR}" 2>/dev/null
       du -sh "${ROOTFS_DIR}"
       sudo "${FIM_BINDIR}/proot" --kill-on-exit -R "${ROOTFS_DIR}" "/bin/bash" -c 'pacman -y --sync --refresh --refresh --sysupgrade --noconfirm'
       sudo rm -rfv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run}
       sudo mkdir -pv "${ROOTFS_DIR}/"{tmp,proc,sys,dev,run/media,mnt,media,home}
       sudo rm -fv "${ROOTFS_DIR}"/etc/{host.conf,hosts,nsswitch.conf}
       sudo touch "${ROOTFS_DIR}"/etc/{host.conf,hosts,nsswitch.conf}
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
     "${FIM_TMPDIR}/artix.flatimage" fim-perms add "audio,dbus_user,dbus_system,gpu,home,input,media,network,udev,usb,xorg,wayland"
     "${FIM_TMPDIR}/artix.flatimage" fim-perms list
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