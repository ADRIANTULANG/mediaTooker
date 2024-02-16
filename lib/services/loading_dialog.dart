import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:sizer/sizer.dart';

class LoadingDialog {
  static showLoadingDialog() async {
    Get.dialog(
        AlertDialog(
          content: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                  height: 8.h,
                  width: 60.w,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Center(
                        child: SpinKitThreeBounce(
                            size: 25.sp, color: AppColors.orange),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "Loading...",
                            style: TextStyle(
                                fontSize: AppFontSizes.regular,
                                color: AppColors.dark),
                          ))
                    ],
                  )),
            ),
          ),
        ),
        barrierDismissible: false);
  }
}
