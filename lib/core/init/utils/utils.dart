import 'package:blue_fire/core/constants/enum/snack_bar_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/app/styles.dart';

class Utils {
  Utils._();
  static Utils? _instance;
  factory Utils() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = Utils._();
      return _instance!;
    }
  }
  final context = Get.context!;
  showSnackBar(String title, String message, SnackBarStatus status) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
        duration: const Duration(seconds: 5),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(15.spMin),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 0.1.sh),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              width: 0.02.sw,
              decoration: BoxDecoration(
                  color: status == SnackBarStatus.success
                      ? Colors.green
                      : status == SnackBarStatus.failure
                          ? Colors.red
                          : Colors.blue,
                  borderRadius: BorderRadius.circular(5.r)),
            ),
            0.05.sw.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Styles.textStyles.f14Bold,
                  ),
                  4.verticalSpace,
                  Text(message,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Styles.textStyles.f14Bold),
                ],
              ),
            ),
            2.horizontalSpace,
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              child: const Icon(
                Icons.close,
                color: Colors.black,
              ),
            )
          ]),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  return SizedBox(
                    height: Get.height * 0.25,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Loading...',
                              style: Styles.textStyles.f18Bold
                                  ?.copyWith(color: Colors.white)),
                          12.verticalSpace,
                          const CupertinoActivityIndicator(
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
  }

  hideLoading() {
    Navigator.pop(context);
  }
}
