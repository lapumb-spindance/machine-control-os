SUMMARY = "A Flutter gRPC example application for controlling an LED."
DESCRIPTION = "A Flutter gRPC example application for controlling an LED."
AUTHOR = "Blake Lapum"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://git@github.com/lapumb-spindance/unleashing-grpc.git;protocol=ssh;branch=master"

PV = "1.0+git${SRCPV}"
SRCREV ?= "${AUTOREV}"

PUBSPEC_APPNAME ?= "${BPN}"
S = "${WORKDIR}/git"
FLUTTER_APPLICATION_PATH = "example/${PUBSPEC_APPNAME}"

FLUTTER_APPLICATION_INSTALL_PREFIX = "${datadir}/apps"
FLUTTER_APP_RUNTIME_MODES="release"

FLUTTER_BUILD_ARGS = "bundle --dart-define=HOSTNAME=${MACHINE}.local"

inherit flutter-app

inherit systemd

RDEPENDS:${PN} += " systemd"

SRC_URI += "file://${BPN}.service"

NATIVE_SYSTEMD_SUPPORT = "1"
SYSTEMD_PACKAGES += " ${PN}"
SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} += " ${BPN}.service"
FILES:${PN} += " ${systemd_unitdir}/system/${BPN}.service"

do_install:append() {
    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/${PN}.service ${D}${systemd_unitdir}/system/
}
