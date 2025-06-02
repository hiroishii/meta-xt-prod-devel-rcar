FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# It is used a lot in the do_install, so variable will be handy
CFG_FILE="${D}${sysconfdir}/xen/doma.cfg"

do_install:append() {
    sed -i ${CFG_FILE} -e "s/vcpus = 4/vcpus = 8/"
    sed -i ${CFG_FILE} -e "s/gl=on/gl=on,show-cursor=on/"
    #sed -i ${CFG_FILE} -e "s/virtio-mouse-pci/virtio-multitouch-pci/"
    #sed -i ${CFG_FILE} -e "s/virtio-mouse-pci/virtio-tablet-pci/"
    sed -i ${CFG_FILE} -e "s/virtio-mouse-pci.*/qemu-xhci',\n'-device', 'usb-wacom-tablet',/"
    #sed -i ${CFG_FILE} -e "s/virtio-mouse-pci.*/virtio-tablet',/"
}

