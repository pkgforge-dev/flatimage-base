#!/usr/bin/env bash
#
##DO NOT RUN DIRECTLY
##Self: bash <(curl -qfsSL "https://raw.githubusercontent.com/pkgforge/flatimage-base/refs/heads/main/blueprint_bootstrap.sh")
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
  "${FIM_TMPDIR}/blueprint.flatimage" fim-perms add "audio,dbus_user,dbus_system,gpu,home,input,media,network,udev,usb,xorg,wayland"
  "${FIM_TMPDIR}/blueprint.flatimage" fim-perms list
  "${FIM_TMPDIR}/blueprint.flatimage" fim-commit
 #Copy
  if [[ -f "${FIM_TMPDIR}/blueprint.flatimage" ]] && [[ $(stat -c%s "${FIM_TMPDIR}/blueprint.flatimage") -gt 10000 ]]; then
     rsync -achLv "${FIM_TMPDIR}/blueprint.flatimage" "${FIM_IMGDIR}"
     realpath "${FIM_IMGDIR}/blueprint.flatimage" | xargs -I {} sh -c 'file {}; sha256sum {}; du -sh {}'
  fi
 popd >/dev/null 2>&1
#-------------------------------------------------------#