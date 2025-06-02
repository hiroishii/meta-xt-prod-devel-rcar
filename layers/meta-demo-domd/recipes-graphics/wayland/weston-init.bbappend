FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:prepend() {
    sed -i ${WORKDIR}/weston.ini \
        -e '$a shell=kiosk-shell.so' \
        -e '$a [output]' \
        -e '$a name=HDMI-A-1' \
        -e '$a app-ids=qemu-system-aarch64' \
        -e '$a [output]' \
        -e '$a name=HDMI-A-2' \
        -e '$a app-ids=cluster'
}

