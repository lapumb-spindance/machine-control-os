FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " file://wpa_supplicant.service file://wpa_supplicant.conf"

BBCLASSEXTEND = "native nativesdk"

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

do_populate_network() {
    # Generate the wpa_passphrase file for the network if the NETWORK_SSID and NETWORK_PASSWORD variables are set.
    if [ -n "${NETWORK_SSID}" ] && [ -n "${NETWORK_PASSWORD}" ]; then
        # Append the network configuration to the wpa_supplicant.conf file.
        wpa_passphrase "${NETWORK_SSID}" ${NETWORK_PASSWORD} >> ${D}${sysconfdir}/wpa_supplicant.conf

        # Add a newline to the end of the wpa_supplicant.conf file.
        echo "" >> ${D}${sysconfdir}/wpa_supplicant.conf

        # Remove the plaintext password line that starts with "[whitespace]#psk=".
        sed -i '/^[[:space:]]#psk=/d' ${D}${sysconfdir}/wpa_supplicant.conf
    fi
}

addtask populate_network after do_populate_sysroot before do_package

# The do_populate_network needs to have access to the native wpa_passphrase command.
do_populate_network[depends] += "wpa-supplicant-native:do_populate_sysroot"

FILES:${PN}:append = " ${systemd_unitdir}/system/wpa_supplicant.service"
FILES:${PN}:append = " ${sysconfdir}/wpa_supplicant.conf"
