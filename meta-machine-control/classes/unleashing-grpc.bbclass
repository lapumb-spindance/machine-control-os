SUMMARY = "A Flutter gRPC example application for controlling an LED."
DESCRIPTION = "A Flutter gRPC example application for controlling an LED."
AUTHOR = "Blake Lapum"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://git@github.com/lapumb-spindance/unleashing-grpc.git;protocol=ssh;branch=master"

### Variables available for override ###

# The commit hash to use for the source code 'master' branch.
SRCREV ?= "${AUTOREV}"

# The name of the application as defined in the pubspec.yaml file.
PUBSPEC_APPNAME ?= "${BPN}"

# The hostname to use for gRPC communication.
GRPC_HOSTNAME ?= "${MACHINE}.local"

# The GPIO number the LED is connected to.
LED_GPIO ?= "6"

### End of variables available for override ###

PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git"
FLUTTER_APPLICATION_PATH = "example/${PUBSPEC_APPNAME}"

FLUTTER_APPLICATION_INSTALL_PREFIX = "${datadir}/apps"
FLUTTER_APP_RUNTIME_MODES="release"

FLUTTER_BUILD_ARGS = "bundle --dart-define=HOSTNAME=${GRPC_HOSTNAME} --dart-define=GPIO=${LED_GPIO}"
APP_AOT_EXTRA = "-DHOSTNAME=${GRPC_HOSTNAME} -DGPIO=${LED_GPIO}"

PUBSPEC_IGNORE_LOCKFILE = "1"

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
