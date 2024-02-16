import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/src/login_users_and_admin_screen/controller/login_users_and_admin_controller.dart';
import 'package:sizer/sizer.dart';

class LoginDialog {
  static showDialogForgotPassword(
      {required LoginViewController controller}) async {
    TextEditingController email = TextEditingController();
    Get.dialog(
      AlertDialog(
        content: Container(
          height: 20.h,
          width: 100.w,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                width: 100.w,
                child: Text(
                  "Enter Email",
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
                height: 7.h,
                width: 100.w,
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                      fillColor: AppColors.light,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 3.w),
                      alignLabelWithHint: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Email'),
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
                        if (email.text.isEmail == true) {
                          controller.forgotPassword(email: email.text);
                        } else {
                          Get.snackbar("Message", "Invalid Email");
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
