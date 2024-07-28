import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/src/admin_reports_screen/controller/admin_reports_controller.dart';
import 'package:sizer/sizer.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_fontsizes.dart';

class AdminReportsAlertDialog {
  static showTerminateOrNot(
      {required String docId, required bool isTerminateOrActivate}) {
    // TextEditingController bio = TextEditingController(text: oldBio);
    var controller = Get.find<AdminReportsController>();
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 1.h,
            ),
            Text(
              isTerminateOrActivate == true
                  ? "Are you sure you want to terminate this user?"
                  : "Are you sure you want to activate this account?",
              style: TextStyle(
                  fontSize: AppFontSizes.regular, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 30.w,
                    child: ElevatedButton(
                        style: const ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll(AppColors.orange),
                            backgroundColor:
                                MaterialStatePropertyAll(AppColors.light)),
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Cancel"))),
                SizedBox(
                    width: 30.w,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          controller.editRestriction(
                              docid: docId, boolean: isTerminateOrActivate);
                        },
                        child: Text(isTerminateOrActivate == true
                            ? "Terminate"
                            : "Activate"))),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ),
    ));
  }
}
