# Enable the wpa_supplicant.service systemd service to automatically start wpa_supplicant on boot.
inherit systemd

SYSTEMD_SERVICE:${PN} = "wpa_supplicant.service"
SYSTEMD_AUTO_ENABLE = "enable"
