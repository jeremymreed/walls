// Needed for ThumbnailFlavor enum.
// ignore_for_file: constant_identifier_names

enum ThumbnailFlavor {
  normal,
  large,
  x_large,
  xx_large,
}

String toHyphenString(String input) {
  return input.replaceAll('_', '-');
}
