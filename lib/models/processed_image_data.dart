// Allows snake case for some names.
// Function names and structs from Rust code are in snake case.
// ignore_for_file: non_constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

final class ProcessedImageData extends ffi.Struct {
  external ffi.Pointer<Utf8> absolute_path;
  external ffi.Pointer<Utf8> format;
  @ffi.Uint32()
  external int width;
  @ffi.Uint32()
  external int height;
  external ffi.Pointer<Utf8> hash;

  @override
  String toString() {
    return "ImageData(absolute_path: ${absolute_path.toDartString()}, format: ${format.toDartString()}, width: $width, height: $height, hash: ${hash.toDartString()})";
  }
}
