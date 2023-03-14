import 'package:blue_fire/core/constants/app/styles.dart';
import 'package:blue_fire/core/models/custom_bluetooth_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Blue Fire',
            style: Styles.textStyles.f16SemiBold,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.spMin),
          child: Obx(() {
            return controller.isScanning.isTrue
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Lottie.asset(
                            'lib/assets/lottie/bluetooth_scanning.json',
                            height: 0.3.sh),
                        8.verticalSpace,
                        Text(
                          'Make sure the device you want to connect is unlocked and bluetooth is enabled.',
                          textAlign: TextAlign.center,
                          style: Styles.textStyles.f14Regular
                              ?.copyWith(color: Colors.grey),
                        ),
                        16.verticalSpace,
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Paired devices',
                            style: Styles.textStyles.f16SemiBold,
                          ),
                        ),
                        12.verticalSpace,
                        DeviceList(
                          devices: controller.pairedDevices,
                          emptyListMessage: 'No paired devices',
                          controller: controller,
                        ),
                        16.verticalSpace,
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Available devices',
                            style: Styles.textStyles.f16SemiBold,
                          ),
                        ),
                        12.verticalSpace,
                        DeviceList(
                          devices: controller.availableDevices,
                          emptyListMessage: 'No devices found in scan',
                          controller: controller,
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await controller.startScanning();
                        },
                        child: Material(
                          elevation: 10.spMin,
                          shape: const CircleBorder(),
                          child: Container(
                            width: double.infinity,
                            height: 0.3.sh,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.yellow,
                                      Colors.red,
                                      Colors.indigo,
                                      Colors.teal,
                                    ])),
                            alignment: Alignment.center,
                            child: Text(
                              'Scan',
                              style: Styles.textStyles.f18Bold
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      16.verticalSpace,
                      Text(
                        controller.isScanning.isTrue
                            ? 'Searching for devices...'
                            : 'Tap above to start scanning',
                        style: Styles.textStyles.f14SemiBold,
                      ),
                    ],
                  );
          }),
        ));
  }
}

class DeviceList extends StatelessWidget {
  const DeviceList({
    super.key,
    required this.devices,
    required this.emptyListMessage,
    required this.controller,
  });
  final HomeController controller;
  final List<CustomBluetoothDevice> devices;
  final String emptyListMessage;

  @override
  Widget build(BuildContext context) {
    return devices.isEmpty
        ? Center(
            child: Text(
              emptyListMessage,
              style:
                  Styles.textStyles.f16SemiBold?.copyWith(color: Colors.grey),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                        color: Colors.grey.shade400, width: 0.5.spMin)),
                padding: EdgeInsets.all(8.spMin),
                child: Obx(() {
                  return Row(
                    children: [
                      8.horizontalSpace,
                      Icon(
                        FontAwesomeIcons.bluetoothB,
                        size: 20.spMin,
                      ),
                      16.horizontalSpace,
                      Text(
                        device.name,
                        style: Styles.textStyles.f14Regular,
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () async {
                            if (device.isConnected.isFalse) {
                              await controller.connect(index);
                            } else {
                              await controller.disconnect(index);
                            }
                          },
                          child: Text(
                            device.isConnected.isTrue
                                ? 'Disconnect'
                                : 'Connect',
                            style: Styles.textStyles.f14SemiBold?.copyWith(
                                color: device.isConnected.isTrue
                                    ? Colors.red
                                    : Colors.green),
                          ))
                    ],
                  );
                }),
              );
            },
          );
  }
}
