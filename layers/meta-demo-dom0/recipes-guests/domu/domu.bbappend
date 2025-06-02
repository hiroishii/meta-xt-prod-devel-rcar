FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# It is used a lot in the do_install, so variable will be handy
CFG_FILE="${D}${sysconfdir}/xen/domu.cfg"

do_install:append() {
    sed -i ${CFG_FILE} -e "s/vcpus = 4/vcpus = 8/"
}

