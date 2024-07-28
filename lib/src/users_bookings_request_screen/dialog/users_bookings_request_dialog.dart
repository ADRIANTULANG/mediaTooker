import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:sizer/sizer.dart';
import '../controller/users_booking_request_controller.dart';

class UsersBookingListAlertDialog {
  static showRemarksDialog({
    required String docid,
    required UsersBookingRequestController controller,
    required String fmcToken,
    required String userid,
    required String projectName,
  }) {
    TextEditingController remarks = TextEditingController();
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
              "Remarks",
              style: TextStyle(
                  fontSize: AppFontSizes.large, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 15.h,
              width: 100.w,
              child: TextField(
                controller: remarks,
                style: TextStyle(fontSize: AppFontSizes.regular),
                maxLines: 15,
                decoration: InputDecoration(
                  fillColor: AppColors.light,
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 3.w, top: 2.h),
                  alignLabelWithHint: false,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3)),
                  hintText:
                      'Say something about this project. e.i reason why you reject this project...',
                ),
              ),
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
                          if (remarks.text.trim().isNotEmpty) {
                            Get.back();
                            controller.rejectProject(
                                docid: docid, remarks: remarks.text);
                            controller.sendNotification(
                                remarks: remarks.text,
                                projectName: projectName,
                                fmcToken: fmcToken,
                                action: "Reject",
                                userid: userid);
                          }
                        },
                        child: const Text("Submit"))),
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
