SUMMARY = "Package of Flutter applications used in the unleashing-grpc stack."

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} += " \
    unleashing-grpc-backend \
    unleashing-grpc-frontend \
"
