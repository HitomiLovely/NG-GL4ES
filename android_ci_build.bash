#!/bin/bash
# set -e

export BUILD_ANDROID=true

cmake_build () {
  ANDROID_ABI=$1
  echo "Building for $ANDROID_ABI..."
  mkdir -p build-$ANDROID_ABI
  mkdir -p lib/$ANDROID_ABI
  cd build-$ANDROID_ABI
  cmake $GITHUB_WORKSPACE -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
    -DANDROID_LD=lld \
    -DANDROID_PLATFORM=24 \
    -DANDROID_ABI=$ANDROID_ABI \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_LATEST_HOME/build/cmake/android.toolchain.cmake
  cmake --build . --clean-first
  cd ..
  cp build-$ANDROID_ABI/*.so lib/$ANDROID_ABI/
}

mkdir -p lib

# List of all target ABIs
ABIS=("armeabi-v7a" "arm64-v8a" "x86" "x86_64")

for ABI in "${ABIS[@]}"; do
  cmake_build $ABI
done
