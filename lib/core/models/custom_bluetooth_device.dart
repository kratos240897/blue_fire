import 'package:flutter_blue/flutter_blue.dart';

class CustomBluetoothDevice {
  late final bool isConnected;
  late final BluetoothDevice bluetoothDevice;
  CustomBluetoothDevice(
      {this.isConnected = false, required this.bluetoothDevice});
}
