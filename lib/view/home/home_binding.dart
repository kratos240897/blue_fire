import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FlutterBlue.instance);
    Get.lazyPut(() => FlutterReactiveBle());
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
