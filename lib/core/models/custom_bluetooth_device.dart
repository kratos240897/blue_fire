import 'package:get/get.dart';

class CustomBluetoothDevice {
  final String name;
  final String address;
  final RxBool isConnected;
  CustomBluetoothDevice(
      {required this.name, required this.address, required this.isConnected});
}
