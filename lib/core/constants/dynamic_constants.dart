import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  bool get is1080x1920 {
    final size = MediaQuery.of(this).size;
    return size.width == 1080 && size.height == 1920;
  }

  double dynamicWidth(double val) {
    if (is1080x1920) {
      return MediaQuery.of(this).size.width * val * 1.1;
    } else {
      return MediaQuery.of(this).size.width * val;
    }
  }

  double dynamicHeight(double val) {
    if (is1080x1920) {
      // Özel ayarlarınız
      return MediaQuery.of(this).size.height * val * 1.1; // Örneğin, %90'ı
    } else {
      return MediaQuery.of(this).size.height * val;
    }
  }

  ThemeData get theme => Theme.of(this);
}
