#!/bin/bash

# output complete rootfs.img to following directory
DESTDIR=~/rootfs-output

# temporary directory to use for building rootfs
TMPDIR=~/.tmp

# git repository to clone
REPO="git://gitorious.org/xdandroid-eclair/eclair-rootfs.git"

# optional, branch to switch to after cloning
#BRANCH="fuze-navipad-remap"

[ ! -d "${DESTDIR}" ] && mkdir -p "${DESTDIR}"
[ ! -d "${TMPDIR}" ] && mkdir -p "${TMPDIR}"
cd ${TMPDIR}

dd if=/dev/zero of=rootfs.img bs=1k count=15k
/sbin/mke2fs -i 1024 -b 1024 -m 5 -F -v rootfs.img
mkdir rootfs
sudo mount -o loop rootfs.img rootfs

REPODIR=${REPO##*/}
REPODIR=${REPODIR%.*}
git clone "${REPO}" "${REPODIR}"
cd "${TMPDIR}"/"${REPODIR}"
[ -z ${BRANCH} ] || git checkout "${BRANCH}"

./scripts/gitclean.sh
sudo cp -a * "${TMPDIR}"/rootfs

cd "${TMPDIR}"/rootfs
sudo ./scripts/distprepare.py

DATE=$(date +%Y%m%d)
cd "${TMPDIR}"
sudo umount "${TMPDIR}"/rootfs
mv rootfs.img "${DESTDIR}"/rootfs-"${DATE}".img
ln -sf "${DESTDIR}"/rootfs-"${DATE}".img "${DESTDIR}"/rootfs.img

rm -Rf rootfs "${REPODIR}"
