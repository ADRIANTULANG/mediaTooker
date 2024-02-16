import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/services/body_wrapper.dart';
import 'package:sizer/sizer.dart';

import '../controller/users_registration_controller.dart';

class UsersRegistrationCredentialsView
    extends GetView<UsersRegistrationViewController> {
  const UsersRegistrationCredentialsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyWrapper(
            child: SizedBox(
      height: 100.h,
      width: 100.w,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 7.h,
            ),
            Container(
              height: 25.h,
              width: 100.w,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'))),
            ),
            SizedBox(
              height: 3.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Text(
                "Credentials",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSizes.extraLarge,
                    color: AppColors.dark),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Text(
                "Email",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.regular,
                ),
              ),
            ),
            SizedBox(
              height: .5.h,
            ),
            Container(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              height: 7.h,
              width: 100.w,
              child: TextField(
                controller: controller.email,
                style: TextStyle(fontSize: AppFontSizes.regular),
                enabled: controller.provider.value == "email" ? true : false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    fillColor: AppColors.light,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 3.w),
                    alignLabelWithHint: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintStyle: const TextStyle(fontFamily: 'Bariol')),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Text(
                "Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.regular,
                ),
              ),
            ),
            SizedBox(
              height: .5.h,
            ),
            Container(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              height: 7.h,
              width: 100.w,
              child: Obx(
                () => TextField(
                  controller: controller.password,
                  style: TextStyle(fontSize: AppFontSizes.regular),
                  obscureText: controller.showPass.value,
                  enabled: controller.provider.value == "email" ? true : false,
                  decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.showPass.value =
                              controller.showPass.value ? false : true;
                        },
                        child: controller.showPass.value
                            ? const Icon(Icons.remove_red_eye_outlined)
                            : const Icon(Icons.remove_red_eye),
                      ),
                      fillColor: AppColors.light,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 3.w),
                      alignLabelWithHint: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintStyle: const TextStyle(fontFamily: 'Bariol')),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Text(
                "Documents",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.regular,
                ),
              ),
            ),
            SizedBox(
              height: .5.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: GestureDetector(
                onTap: () {
                  controller.getFile();
                },
                child: Container(
                  height: 22.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.light,
                  ),
                  child: Center(
                    child: Obx(() => controller.filepath.value == ""
                        ? const Icon(Icons.drive_folder_upload_rounded)
                        : const Icon(
                            Icons.drive_folder_upload_rounded,
                            color: AppColors.orange,
                          )),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: SizedBox(
                width: 100.w,
                height: 7.h,
                child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(AppColors.dark),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColors.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(color: Colors.white)))),
                  onPressed: () {
                    if (controller.provider.value == "email") {
                      if (controller.email.text.isEmpty ||
                          controller.filepath.value.isEmpty ||
                          controller.password.text.isEmpty) {
                        Get.snackbar("Message", "Missing input.",
                            backgroundColor: AppColors.orange,
                            colorText: AppColors.light);
                      } else if (controller.email.text.isEmail == false) {
                        Get.snackbar("Message", "Invalid email.",
                            backgroundColor: AppColors.orange,
                            colorText: AppColors.light);
                      } else {
                        controller.signUpEmailUser();
                      }
                    } else {
                      if (controller.filepath.value.isEmpty) {
                        Get.snackbar("Message", "Missing input.",
                            backgroundColor: AppColors.orange,
                            colorText: AppColors.light);
                      } else {
                        controller.signUpGmailUser();
                      }
                    }
                  },
                  child: Text("CREATE",
                      style: TextStyle(
                          fontSize: AppFontSizes.regular, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
