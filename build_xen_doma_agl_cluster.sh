#!/bin/bash

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

moulin prod-devel-rcar-virtio.yaml \
    --MACHINE "$target" \
    --ENABLE_ANDROID yes \
    --ENABLE_DOMU no \
    --GRAPHICS binaries \

[ ! -f "./scripts/tweak_build_ninja.sh" ] && die "no such file: ./scripts/tweak_build_ninja.sh"
./scripts/tweak_build_ninja.sh

# Cleanup build directory
rm -rf firmware
find ../common_data/sstate | grep xen: | xargs rm -r
find ../common_data/sstate | grep arm-trusted-firmware: | xargs rm -r
find ../common_data/sstate | grep core-image-thin-initramfs: | xargs rm -r

ninja || die "build failed"
ninja full.img.gz || die "build failed"
cp full.img.gz /srv/tftp/

mkdir -p firmware
find ./yocto/build-domd/tmp/deploy/images/ -name "*.srec" | xargs cp -t firmware

