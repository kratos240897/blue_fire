import 'dart:async';

import 'package:blue_fire/core/constants/enum/snack_bar_status.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/init/utils/utils.dart';
import '../../core/models/custom_bluetooth_device.dart';

class HomeController extends GetxController {
  final isScanning = false.obs;
  var _isBluetoothPermissionGranted = false;
  var _isBluetoothScanPermissionGranted = false;
  var _isBluetoothConnectPermissionGranted = false;
  final _flutterBlue = Get.find<FlutterBlue>();
  late final StreamSubscription<List<ScanResult>> scanResultsSubscription;
  final RxList<CustomBluetoothDevice> availableDevices = RxList.empty();

  @override
  void onReady() async {
    scanResultsSubscription = _flutterBlue.scanResults.listen((results) {
      for (var result in results) {
        availableDevices
            .add(CustomBluetoothDevice(bluetoothDevice: result.device));
      }
    });
    await _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.location,
    ].request();
    _isBluetoothPermissionGranted =
        (statuses[Permission.bluetooth] as PermissionStatus).isGranted;

    _isBluetoothScanPermissionGranted =
        (statuses[Permission.bluetoothScan] as PermissionStatus).isGranted;

    _isBluetoothConnectPermissionGranted =
        (statuses[Permission.bluetoothConnect] as PermissionStatus).isGranted;
  }

  Future<void> startScanning() async {
    if (!_isBluetoothPermissionGranted ||
        !_isBluetoothScanPermissionGranted ||
        !_isBluetoothConnectPermissionGranted) {
      Utils().showSnackBar(
          'Info',
          'Please allow permission to bluetooth to continue',
          SnackBarStatus.info);
      await _checkPermissions();
      return;
    }
    final isBluetoothTurnedOn = await _flutterBlue.isOn;
    if (!isBluetoothTurnedOn) {
      Utils().showSnackBar('Info', 'Please turn on Bluetooth to start scanning',
          SnackBarStatus.info);
      return;
    }
    isScanning.value = true;
    await _flutterBlue
        .startScan(timeout: const Duration(seconds: 30))
        .then((value) => isScanning.value = false);
  }

  Future<void> connect(int index) async {
    final device = availableDevices[index];
    await device.bluetoothDevice.connect();
    Utils().showSnackBar(
        'Success',
        'Connected to device ${device.bluetoothDevice.name}',
        SnackBarStatus.success);
  }

  Future<void> disconnect(int index) async {
    final device = availableDevices[index];
    await device.bluetoothDevice.disconnect();
    Utils().showSnackBar(
        'Success',
        'Disconnected from device ${device.bluetoothDevice.name}',
        SnackBarStatus.success);
  }

  @override
  void dispose() {
    _stopScanning();
    super.dispose();
  }

  Future<void> _stopScanning() async {
    if (isScanning.isTrue) {
      await _flutterBlue.stopScan();
    }
  }
}
