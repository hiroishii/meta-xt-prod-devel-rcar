
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append() {
    sed -i '/\[core\]/c\\[core\]\nuse-pixman=true' \
        ${D}/${sysconfdir}/xdg/weston/weston.ini
}
