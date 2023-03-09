// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class Styles {
  static final colors = _Colors();
  static final textStyles = _TextStyles();
}

class _Colors {
  final primaryColor = _getMaterialColorFromColor(Colors.black);

  static MaterialColor _getMaterialColorFromColor(Color color) {
    Map<int, Color> colorShades = {
      50: _getShade(color, value: 0.5),
      100: _getShade(color, value: 0.4),
      200: _getShade(color, value: 0.3),
      300: _getShade(color, value: 0.2),
      400: _getShade(color, value: 0.1),
      500: color, //Primary value
      600: _getShade(color, value: 0.1, darker: true),
      700: _getShade(color, value: 0.15, darker: true),
      800: _getShade(color, value: 0.2, darker: true),
      900: _getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, colorShades);
  }

  static Color _getShade(Color color,
      {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness(
        (darker ? (hsl.lightness - value) : (hsl.lightness + value))
            .clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

class _TextStyles {
  final f12Regular = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 12.sp,
      );
  final f12SemiBold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      );
  final f12Bold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
      );
  final f14Regular = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 14.sp,
      );
  final f14SemiBold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      );
  final f14Bold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      );
  final f16Regular = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 16.sp,
      );
  final f16SemiBold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      );
  final f16Bold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      );
  final f18Regular = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 18.sp,
      );
  final f18SemiBold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      );
  final f18Bold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      );
  final f20Regular = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 20.sp,
      );
  final f20SemiBold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      );
  final f20Bold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      );
  final f22Regular = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 22.sp,
      );
  final f22SemiBold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
      );
  final f22Bold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      );
}
