import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/init/routes/app_pages.dart';

void main() {
  runApp(
    ScreenUtilInit(
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Application",
          theme: ThemeData(
            fontFamily: GoogleFonts.poppins().fontFamily
          ),
          initialRoute: Routes.HOME,
          getPages: AppPages.routes,
        );
      }
    ),
  );
}
