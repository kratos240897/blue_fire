// ignore_for_file: avoid_print

import 'dart:async';

import 'package:blue_fire/core/constants/enum/snack_bar_status.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/init/utils/utils.dart';
import '../../core/models/custom_bluetooth_device.dart';

class HomeController extends GetxController {
  static const _platform = MethodChannel('com.mythstudios.blue_fire/bluetooth');
  late Timer _timer;
  final isScanning = false.obs;
  var _isBluetoothScanPermissionGranted = false;
  var _isBluetoothConnectPermissionGranted = false;
  final _flutterBlue = Get.find<FlutterBlue>();
  final _flutterReactiveBle = Get.find<FlutterReactiveBle>();
  final RxList<CustomBluetoothDevice> pairedDevices = RxList.empty();
  final RxList<CustomBluetoothDevice> availableDevices = RxList.empty();

  @override
  void onReady() async {
    await _checkPermissions();
    await _getPairedDevices();
  }

  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();

    _isBluetoothScanPermissionGranted =
        (statuses[Permission.bluetoothScan] as PermissionStatus).isGranted;

    _isBluetoothConnectPermissionGranted =
        (statuses[Permission.bluetoothConnect] as PermissionStatus).isGranted;
  }

  Future<void> startScanning() async {
    if (!_isBluetoothScanPermissionGranted ||
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
    _flutterReactiveBle.scanForDevices(withServices: []).listen((event) {
      final device = CustomBluetoothDevice(
          name: event.name.isNotEmpty ? event.name : 'Unknown Device',
          address: event.id,
          isConnected: false.obs);
      availableDevices.add(device);
    });
    // await _platform.invokeMethod('startScanning');
    // _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
    //   final List<dynamic> result =
    //       await _platform.invokeMethod('getScannedDevices');
    //   for (var element in result) {
    //     availableDevices.add(CustomBluetoothDevice(
    //         name: element['name'],
    //         address: element['address'],
    //         isConnected: false));
    //   }
    // });
  }

  Future<void> _getPairedDevices() async {
    final List<dynamic> result =
        await _platform.invokeMethod('getPairedDevices');
    for (var element in result) {
      pairedDevices.add(CustomBluetoothDevice(
          name: element['name'],
          address: element['address'],
          isConnected: false.obs));
    }
  }

  Future<void> connect(int index) async {
    final device = availableDevices[index];
    try {
      _flutterReactiveBle
          .connectToDevice(
              id: device.address,
              connectionTimeout: const Duration(seconds: 10))
          .listen((event) {
        if (event.connectionState == DeviceConnectionState.connected) {
          Utils().showSnackBar('Success', 'Connected to device ${device.name}',
              SnackBarStatus.success);
        }
      });
      device.isConnected.value = true;
    } catch (e) {
      Utils().showSnackBar('Success',
          'Failed to connect to device ${device.name}', SnackBarStatus.success);
    }
  }

  Future<void> disconnect(int index) async {
    final device = availableDevices[index];
    device.isConnected.value = false;
    Utils().showSnackBar('Success', 'Disconnected from device ${device.name}',
        SnackBarStatus.success);
  }

  @override
  void dispose() {
    _stopScanning();
    super.dispose();
  }

  Future<void> _stopScanning() async {
    _timer.cancel();
    if (isScanning.isTrue) {
      await _platform.invokeMethod('stopScanning');
    }
  }
}
