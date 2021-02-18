
set -e

# If we're already inside this script then die
if [ -n "$MULTIPLATFORM_BUILD_IN_PROGRESS" ]; then
  exit 0
fi
export MULTIPLATFORM_BUILD_IN_PROGRESS=1

DISTRIBUTION_DIR="${PROJECT_DIR}/Products"
TARGET_PRODUCT_NAME="Authenticator"
# The directory to contain the distribution build of the framework will include a representation of the 
# the current date (e.g. "1493930397") and the short git commit hash (e.g. "e3ce5c8").
DATE_COMMIT_TAG="`date +%s`.`git rev-parse --short HEAD`"
DIST_BUILD_DIR="${BUILD_DIR}/${TARGET_PRODUCT_NAME}_${DATE_COMMIT_TAG}"
UNIVERSAL_FRAMEWORK_LOCATION="${DIST_BUILD_DIR}/${TARGET_PRODUCT_NAME}.framework"
FRAMEWORK_LOCATION="${BUILT_PRODUCTS_DIR}/${TARGET_PRODUCT_NAME}.framework"

function build_dynamic_library {
    echo "build_dynamic_library sdk=$1 date.commit=${DATE_COMMIT_TAG}"
    ALT_OBJROOT="`dirname ${OBJROOT}`/${DATE_COMMIT_TAG}/`basename ${OBJROOT}`"
    echo ALT_OBJROOT: ${ALT_OBJROOT}

    xcrun xcodebuild -project "${PROJECT_FILE_PATH}" \
                     -target "${TARGET_NAME}" \
                     -configuration "${CONFIGURATION}" \
                     -sdk "${1}" \
                     BUILD_DIR="${BUILD_DIR}" \
                     OBJROOT="${ALT_OBJROOT}" \
                     BUILD_ROOT="${BUILD_ROOT}" \
                     SYMROOT="${SYMROOT}" $ACTION
}

function make_fat_library {
    echo "make_fat_library input1=$1 input2=$2 output=$3"

    # Will smash 2 static libs together
    #     make_fat_library in1 in2 out
    xcrun lipo -create "${1}" "${2}" -output "${3}"
    # Strip out symbols.
    xcrun strip -x "${3}"
}

# 1 - Extract the platform (iphoneos/iphonesimulator) from the SDK name
if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]; then
    SDK_PLATFORM=${BASH_REMATCH[1]}
else
    echo "Could not find platform name from SDK_NAME: $SDK_NAME"
    exit 1
fi

echo SDK_PLATFORM: $SDK_PLATFORM

# 2 - Extract the version from the SDK
if [[ "$SDK_NAME" =~ ([0-9]+.*$) ]]; then
    SDK_VERSION=${BASH_REMATCH[1]}
else
    echo "Could not find sdk version from SDK_NAME: $SDK_NAME"
    exit 1
fi

# 3 - Determine the other platform
if [ "$SDK_PLATFORM" == "iphoneos" ]; then
    OTHER_PLATFORM=iphonesimulator
    DEVICE_PRODUCT_DIR="${BUILT_PRODUCTS_DIR}"
    DEVICE_FRAMEWORK_LOCATION="${FRAMEWORK_LOCATION}"
else
    OTHER_PLATFORM=iphoneos
fi

# 4 - Find the build directory
if [[ "$BUILT_PRODUCTS_DIR" =~ (.*)$SDK_PLATFORM$ ]]; then
    OTHER_BUILT_PRODUCTS_DIR="${BASH_REMATCH[1]}${OTHER_PLATFORM}"
    OTHER_FRAMEWORK_LOCATION="${OTHER_BUILT_PRODUCTS_DIR}/${TARGET_PRODUCT_NAME}.framework"
    DEVICE_PRODUCT_DIR=${DEVICE_PRODUCT_DIR:=$OTHER_BUILT_PRODUCTS_DIR}
    DEVICE_FRAMEWORK_LOCATION=${DEVICE_FRAMEWORK_LOCATION:=$OTHER_FRAMEWORK_LOCATION}
else
    echo "Could not find other platform build directory."
    exit 1
fi

# Build the other platform. (The building of the SDK_PLATFORM is ensured via the "Target Dependencies"
# of the "Aggregate" Xcode target that hosts this script.
build_dynamic_library "${OTHER_PLATFORM}${SDK_VERSION}"

mkdir "${DIST_BUILD_DIR}"
mkdir "${UNIVERSAL_FRAMEWORK_LOCATION}"
# We source the device framework for these non-code resources because the Info.plist file differs based
# on the platform (and we want the device-appropriate version).
cp -a "${DEVICE_FRAMEWORK_LOCATION}/Headers" "${UNIVERSAL_FRAMEWORK_LOCATION}/."
cp -a "${DEVICE_FRAMEWORK_LOCATION}/Modules" "${UNIVERSAL_FRAMEWORK_LOCATION}/."
cp -a "${DEVICE_FRAMEWORK_LOCATION}/Info.plist" "${UNIVERSAL_FRAMEWORK_LOCATION}/."
cp -a "${DEVICE_FRAMEWORK_LOCATION}/"*.nib "${UNIVERSAL_FRAMEWORK_LOCATION}/."
cp -a "${DEVICE_FRAMEWORK_LOCATION}/"*.storyboardc "${UNIVERSAL_FRAMEWORK_LOCATION}/."
cp -a "${DEVICE_FRAMEWORK_LOCATION}/"*.car "${UNIVERSAL_FRAMEWORK_LOCATION}/."
cp -a "${DEVICE_FRAMEWORK_LOCATION}/"*.lproj "${UNIVERSAL_FRAMEWORK_LOCATION}/."
# Don't forget to include certificate files (which should always have the .der extension).
cp -a "${DEVICE_FRAMEWORK_LOCATION}/"*.der "${UNIVERSAL_FRAMEWORK_LOCATION}/."

# Join the two dynamic libs into a singular, multi-platform, 5-architecture binary file.
make_fat_library "${FRAMEWORK_LOCATION}/${TARGET_PRODUCT_NAME}" \
                 "${OTHER_FRAMEWORK_LOCATION}/${TARGET_PRODUCT_NAME}" \
                 "${UNIVERSAL_FRAMEWORK_LOCATION}/${TARGET_PRODUCT_NAME}"

# Save the bcsymbolmap files in the current distribution directory. (We move rather than copy since these
# files will otherwise accumulate in the Release-iphoneos directory, since they have unique names, and they
# are only relevant to this specific build.)
DIST_BITCODE_SYM_DIR="${DIST_BUILD_DIR}/BCSymbolMaps"
mkdir "${DIST_BITCODE_SYM_DIR}"
for DEVICE_LIB_UUID in `xcrun dwarfdump --uuid "${DEVICE_FRAMEWORK_LOCATION}/${TARGET_PRODUCT_NAME}" | awk '{ print $2 }'`; do
    echo "bringing bcsymbolmap $DEVICE_LIB_UUID into distribution dir"
    mv "${DEVICE_PRODUCT_DIR}/${DEVICE_LIB_UUID}.bcsymbolmap" "${DIST_BITCODE_SYM_DIR}/."
done

# Save (this time via copy) the framework dSYM file in the current distribution directory.
DIST_DSYM_DIR="${DIST_BUILD_DIR}/dSYMs"
FRAMEWORK_DSYM_NAME="${TARGET_PRODUCT_NAME}.framework.dSYM"
mkdir "${DIST_DSYM_DIR}"
cp -a "${BUILT_PRODUCTS_DIR}/${FRAMEWORK_DSYM_NAME}" "${DIST_DSYM_DIR}/${TARGET_PRODUCT_NAME}-${SDK_PLATFORM}.dSYM"
cp -a "${OTHER_BUILT_PRODUCTS_DIR}/${FRAMEWORK_DSYM_NAME}" "${DIST_DSYM_DIR}/${TARGET_PRODUCT_NAME}-${OTHER_PLATFORM}.dSYM"

# The other "DIST_" paths relate to the location for a final/distributable build. The DISTRIBUTION_DIR
# path identifies a folder that serves as a distribution target.
mkdir -p "$DISTRIBUTION_DIR"
DISTRIBUTION_DIR_UNI="${DISTRIBUTION_DIR}/Frameworks-universal"
if [ ! -d "$DISTRIBUTION_DIR_UNI" ]; then
    mkdir "${DISTRIBUTION_DIR_UNI}"
fi
cp -a "${UNIVERSAL_FRAMEWORK_LOCATION}" "${DISTRIBUTION_DIR_UNI}/."

DISTRIBUTION_DIR_SYMBOLMAP="${DISTRIBUTION_DIR}/Frameworks-bcsymbolmap"
if [ ! -d "$DISTRIBUTION_DIR_SYMBOLMAP" ]; then
    mkdir "${DISTRIBUTION_DIR_SYMBOLMAP}"
fi
# The * wildcard must appear outside of the quoted string for it to produce the expected result of
# expanding to include all of the matching files.
cp -a "${DIST_BITCODE_SYM_DIR}"/*.bcsymbolmap "${DISTRIBUTION_DIR_SYMBOLMAP}/."
