#!/bin/bash

agl_versions=(-b salmon -m salmon_19.0.2.xml)
AGL_TARGET_IMAGE=agl-ivi-demo-flutter-guest
AGL_SITE_CONF=site.conf

die () {
    echo >&2 "$(basename "$0"):${BASH_LINENO[0]}: ERROR:" "$@" && exit 1
}

Usage() {
    echo "Usage: $0 <target_board>"
    echo "board list:"
    echo "- h3ulcb-4x2g-kf (h3sk 8GB + kingfisher board)"
    echo "- h3ulcb-4x2g-ab (h3sk 8GB + ccpf-sk board)"
    echo "- salvator-xs-h3-4x2g (Salvator-XS with H3 8GB)"
    echo ""
}
target="$1"
if [ -z "$target" ]; then
    target="h3ulcb-4x2g-kf"
    echo "default target: $target"
fi

if [[ "$target" != "h3ulcb-4x2g-kf" ]] && 
    [[ "$target" != "h3ulcb-4x2g-ab" ]] && 
    [[ "$target" != "salvator-xs-h3-4x2g" ]]; then
    echo "Error: This board is not supported: $target"
    Usage; exit -1
fi

[ ! -f "./scripts/prepare_build_environment.sh" ] && die "no such file: ./scripts/prepare_build_environment.sh"
source ./scripts/prepare_build_environment.sh

WORK="$PWD"

moulin prod-devel-rcar-virtio.yaml \
    --MACHINE "$target" \
    --ENABLE_ANDROID no \
    --ENABLE_DOMU_AGL yes \
    --GRAPHICS binaries \

[ ! -f "./scripts/tweak_build_ninja.sh" ] && die "no such file: ./scripts/tweak_build_ninja.sh"
./scripts/tweak_build_ninja.sh

# build AGL IVI as DomU image
[ -f "$AGL_SITE_CONF" ] && AGL_SITE_CONF="$PWD/$AGL_SITE_CONF" || unset AGL_SITE_CONF

mkdir -p agl-ivi
cd agl-ivi

if [ ! -d "meta-agl" ]; then
    repo init "${agl_versions[@]}" -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo
    repo sync -j8
fi

if [ ! -d "build" ]; then
    source meta-agl/scripts/aglsetup.sh -m virtio-aarch64 -b build agl-demo agl-devel agl-kvm
else
    source build/agl-init-build-env
fi
[ -n "$AGL_SITE_CONF" ] && cp -f "$AGL_SITE_CONF" ./conf/

bitbake "$AGL_TARGET_IMAGE" || die "building agl-ivi failed"

cd "$WORK"


# Cleanup build directory
rm -rf firmware
find ../common_data/sstate | grep xen: | xargs rm -r
find ../common_data/sstate | grep arm-trusted-firmware: | xargs rm -r
find ../common_data/sstate | grep core-image-thin-initramfs: | xargs rm -r
find ../common_data/sstate | grep linux-renesas: | xargs rm -r

ninja
ninja full.img.gz
cp full.img.gz /srv/tftp/

mkdir -p firmware
find ./yocto/build-domd/tmp/deploy/images/ -name "*.srec" | xargs cp -t firmware

