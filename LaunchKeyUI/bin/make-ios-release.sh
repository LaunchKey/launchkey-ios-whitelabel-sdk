set -e

# If we're already inside this script then die
if [ -n "$SDK_BUILD_IN_PROGRESS" ]; then
    exit 0
fi
export SDK_BUILD_IN_PROGRESS=1

# Figure out the branch tag.
GIT_COMMIT=${GIT_COMMIT:=`git rev-parse --short HEAD`}
GIT_SHORT_BRANCH=`basename ${GIT_BRANCH:=$GIT_COMMIT}`

BUILD_EPOCH=$(date +%s)
DISTBUILD=$BUILD_EPOCH.$GIT_SHORT_BRANCH

# Zip it up.
ditto -ck --norsrc "${PROJECT_DIR}/Products/Frameworks-universal" "${PROJECT_DIR}/jenkins/Authenticator_${DISTBUILD}.zip"
