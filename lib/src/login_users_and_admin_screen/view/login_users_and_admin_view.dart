import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/services/body_wrapper.dart';
import 'package:mediatooker/src/login_users_and_admin_screen/alertdialog/login_users_and_admin_alertdialog.dart';
import 'package:mediatooker/src/login_users_and_admin_screen/controller/login_users_and_admin_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:mediatooker/config/app_colors.dart';

import '../../admin_passcode_screen/view/admin_passcode_view.dart';
import '../../users_registration_screen/view/users_registration_basic_info_view.dart';

class LoginView extends GetView<LoginViewController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginViewController());
    return Scaffold(
      body: BodyWrapper(
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: SingleChildScrollView(
            child: Column(
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
                  height: 10.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  height: 7.h,
                  width: 100.w,
                  child: TextField(
                    controller: controller.email,
                    style: TextStyle(fontSize: AppFontSizes.regular),
                    decoration: InputDecoration(
                        fillColor: AppColors.light,
                        filled: true,
                        contentPadding: EdgeInsets.only(left: 3.w),
                        alignLabelWithHint: false,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        hintText: 'Email',
                        hintStyle: const TextStyle(fontFamily: 'Bariol')),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  height: 7.h,
                  width: 100.w,
                  child: Obx(
                    () => TextField(
                      controller: controller.password,
                      obscureText: controller.showPass.value,
                      style: TextStyle(fontSize: AppFontSizes.regular),
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
                          hintText: 'Password',
                          hintStyle: const TextStyle(fontFamily: 'Bariol')),
                    ),
                  ),
                ),
                SizedBox(
                  height: .2.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      LoginDialog.showDialogForgotPassword(
                          controller: controller);
                    },
                    child: Text("Forgot Password?",
                        style: TextStyle(fontSize: AppFontSizes.small)),
                  ),
                ),
                SizedBox(
                  height: 3.h,
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
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.orange),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: const BorderSide(
                                          color: Colors.white)))),
                      onPressed: () {
                        if (controller.email.text.isEmpty ||
                            controller.password.text.isEmpty) {
                          Get.snackbar("Message", "Missing input.",
                              backgroundColor: AppColors.orange,
                              colorText: AppColors.light);
                        } else if (controller.email.text.isEmail == false) {
                          Get.snackbar("Message", "Invalid email.",
                              backgroundColor: AppColors.orange,
                              colorText: AppColors.light);
                        } else {
                          controller.loginClient();
                        }
                      },
                      child: Text("LOGIN",
                          style: TextStyle(
                              fontSize: AppFontSizes.regular,
                              color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont have an account?",
                        style: TextStyle(fontSize: AppFontSizes.regular)),
                    SizedBox(
                      width: 1.w,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const UsersRegistrationView(), arguments: {
                          "provider": "email",
                          "email": "",
                          "useridFromGmail": ""
                        });
                      },
                      child: Text("Create account here.",
                          style: TextStyle(
                              fontSize: AppFontSizes.regular,
                              color: AppColors.orange,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: InkWell(
                    onTap: () async {
                      controller.googleSignin();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 6.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/googles.png"),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              "Sign in with Google",
                              style: TextStyle(
                                  fontSize: AppFontSizes.regular,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: InkWell(
                    onTap: () async {
                      Get.to(() => const AdminPassCodeView());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 6.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.admin_panel_settings_sharp,
                              color: AppColors.orange,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              "Continue as Admin",
                              style: TextStyle(
                                  fontSize: AppFontSizes.regular,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
