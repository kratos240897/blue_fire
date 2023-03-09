import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FlutterBlue.instance);
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
