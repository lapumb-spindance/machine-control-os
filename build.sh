#!/bin/bash -e

# Print the build information.
#
# Args: None
#
# Returns: None
function print_build_info {
    set -u
    echo "================================================================"
    echo "Build information:"
    echo "    Target: $TARGET"
    echo "    USER_BB_NUMBER_THREADS: $USER_BB_NUMBER_THREADS"
    echo "    USER_PARALLEL_MAKE: $USER_PARALLEL_MAKE"
    echo "    Build directory: $BUILD_DIR"
    echo "    SSTATE_DIR: $USER_SSTATE_DIR"
    echo "    DL_DIR: $USER_DL_DIR"
    echo "    Output image directory: $OUTPUT_IMAGE_DIR"
    echo "================================================================"
    set +u
}

# Build the image, and display the amount of time it took to build.
#
# Args: None
#
# Returns: None
function bitbake_build_with_time {
    # Get the current time, in seconds.
    local start_time=$(date +%s)

    # Build the target.
    ./execute_bitbake.sh $TARGET

    # Get the current time, in seconds.
    local end_time=$(date +%s)

    # Display the amount of time it took to build.
    local elapsed=$((end_time - start_time))
    local time_format=$(date -d@$elapsed -u +%H:%M:%S)
    echo "Build complete, total time: $time_format ($elapsed seconds)."
}

# Copy any images that were generated from the build into a local directory.
#
# Args: None
#
# Returns: None
function copy_build_images {
    local build_image_dir="${BUILD_DIR}/tmp/deploy/images"
    cp -p $build_image_dir -r $OUTPUT_IMAGE_DIR

    echo "Successfully copied generated images ($build_image_dir) into '${OUTPUT_IMAGE_DIR}'"
}

# Find the latest wic file, which is probably a symlink.
#
# Args: None
#
# Returns: None
function prepare_wic_file {
    local wic_file=$(find $OUTPUT_IMAGE_DIR -name "*.wic" | sort -r | head -n 1)
    echo "Found newest wic file: $wic_file! Use the flash.sh script to flash the image to an SD card."
}

#############################################
# Main Script
#############################################

# Make sure we are in the directory where this script lives.
cd "$(dirname "$0")"

# Ensure the environment is setup.
source .envrc

# This script is not expecting any arguments. If any are provided, print an error and exit. 
if [ $# -ne 0 ]; then
    echo "ERROR: This script utilizes environment variables to build and thus does not expect any arguments."
    exit 1
fi

print_build_info

bitbake_build_with_time

copy_build_images

prepare_wic_file
