FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " file://wpa_supplicant.service file://wpa_supplicant.conf"

# Enable the wpa_supplicant.service systemd service to automatically start wpa_supplicant on boot.
inherit systemd

SYSTEMD_SERVICE:${PN} = "wpa_supplicant.service"
SYSTEMD_AUTO_ENABLE = "enable"

do_install:append() {
    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/wpa_supplicant.service ${D}${systemd_unitdir}/system/

    install -d ${D}${sysconfdir}/
    install -m 0644 ${WORKDIR}/wpa_supplicant.conf ${D}${sysconfdir}/wpa_supplicant.conf
}

FILES:${PN}:append = " ${systemd_unitdir}/system/wpa_supplicant.service"
FILES:${PN}:append = " ${sysconfdir}/wpa_supplicant.conf"
