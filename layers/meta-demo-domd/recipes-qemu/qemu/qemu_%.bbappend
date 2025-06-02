FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-virtio-input-generalize-virtio_input_key_config.patch \
    file://0002-ui-add-the-infrastructure-to-support-MT-events.patch \
    file://0003-virtio-input-add-a-virtio-mulitouch-device.patch \
    file://0004-virtio-input-pci-add-virtio-multitouch-pci.patch \
    file://0005-ui-add-helpers-for-virtio-multitouch-events.patch \
    file://0006-ui-gtk-enable-backend-to-send-multi-touch-events.patch \
"

SRC_URI:append = " \
    file://0001-hw-input-virtio-input-hid-Force-to-default-wheel-axi.patch \
"

