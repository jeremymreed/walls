#!/usr/bin/env bash

# Release build.
echo "Building walls in release mode."
echo "Building libimage_decoder.so"
cd packages/image_decoder/
cargo build --release
cd ../../
echo "Moving build artifacts"
cp packages/image_decoder/target/release/libimage_decoder.so libs/
echo "Building flutter project"
flutter build linux
