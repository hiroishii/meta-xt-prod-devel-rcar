FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://uinput.cfg \
    file://0001-Change-display-order-for-drgb-out.patch \
"

