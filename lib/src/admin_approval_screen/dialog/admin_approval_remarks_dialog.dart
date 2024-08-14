import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:sizer/sizer.dart';

import '../controller/admin_approval_controller.dart';

class AdminApprovalRemarksDialog {
  static showRemarksDialog({
    required AdminApprovalController controller,
    required String docid,
    required String email,
    required String name,
  }) async {
    TextEditingController remarks = TextEditingController();
    Get.dialog(
      AlertDialog(
        content: Container(
          height: 35.h,
          width: 100.w,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                width: 100.w,
                child: Text(
                  "Remarks",
                  style: TextStyle(
                      color: AppColors.dark,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.regular),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                height: 20.h,
                width: 100.w,
                child: TextField(
                  controller: remarks,
                  maxLines: 15,
                  decoration: InputDecoration(
                      fillColor: AppColors.light,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 3.w, top: 2.h),
                      alignLabelWithHint: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Say something why this account is rejected.'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Back",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.regular,
                            color: AppColors.dark),
                      )),
                  TextButton(
                      onPressed: () {
                        if (remarks.text.trim().toString().isNotEmpty == true) {
                          controller.rejectUsers(
                              docid: docid,
                              email: email,
                              name: name,
                              remarks: remarks.text);
                        } else {
                          Get.snackbar("Message", "Invalid remarks");
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.regular),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
