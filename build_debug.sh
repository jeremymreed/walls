#!/usr/bin/env bash

# Release build.
echo "Building walls in debug mode."
cd packages/image_decoder/
cargo build
cd ../../
echo "Moving build artifacts"
cp packages/image_decoder/target/debug/libimage_decoder.so libs/
echo "Building flutter project"
flutter build linux --debug
