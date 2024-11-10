enum Mode {
  oneshot,
  slideshow,
}

extension ModeToStringExtension on Mode {
  String toShortString() {
    switch (this) {
      case Mode.oneshot:
        return 'Oneshot';
      case Mode.slideshow:
        return 'Slideshow';
    }
  }
}
