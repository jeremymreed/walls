// Allows snake case for some names.
// Function names and structs from Rust code are in snake case.
// ignore_for_file: non_constant_identifier_names

// Remember that memory allocated by the Rust code must be freed by the Rust code.

import 'package:walls/main.dart';
import 'dart:io';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:walls/models/processed_image_data.dart';
import 'package:walls/models/image_entry.dart';

final class ProcessFileResponse extends ffi.Struct {
  @ffi.Int32()
  external int status;
  external ProcessedImageData image_data;

  @override
  String toString() {
    return "ProcessFileResponse(status: $status, image_data: $image_data)";
  }
}

// proces_file typedefs.
typedef ProcessFileFunc = ProcessFileResponse Function(ffi.Pointer<Utf8> path);
typedef ProcessFile = ProcessFileResponse Function(ffi.Pointer<Utf8> path);

// Free ImageData strings.
typedef FreeImageDataFunc = ffi.Void Function(ProcessedImageData image);
typedef FreeImageData = void Function(ProcessedImageData image);

class ImageValidator {
  final ffi.DynamicLibrary dl;
  final ProcessFile process_file;
  final FreeImageData free_image_data;

  ImageValidator()
      : dl = ffi.DynamicLibrary.open('libs/libimage_decoder.so'),
        free_image_data = ffi.DynamicLibrary.open('libs/libimage_decoder.so')
            .lookup<ffi.NativeFunction<FreeImageDataFunc>>('free_image_data')
            .asFunction(),
        process_file = ffi.DynamicLibrary.open('libs/libimage_decoder.so')
            .lookup<ffi.NativeFunction<ProcessFileFunc>>('process_file')
            .asFunction();

  // We are supporting only JPEG, and PNG files.
  ImageEntry? isSupportedImage(String path) {
    final Uint8List bytes = File(path).readAsBytesSync();

    ImageEntry? imageEntry;

    final ffi.Pointer<Utf8> pathPtr = path.toNativeUtf8();
    final ProcessFileResponse response = process_file(pathPtr);

    if (response.status == 0) {
      final String hash = sha256.convert(bytes).toString();

      imageEntry = ImageEntry(
        path: path,
        hash: hash,
        width: response.image_data.width,
        height: response.image_data.height,
        imported: DateTime.now(),
      );
    } else {
      loggerWrapper.error('$path is not valid.  Returning null.');
      imageEntry = null;
    }

    free_image_data(response.image_data);

    calloc.free(pathPtr);

    return imageEntry;
  }
}
