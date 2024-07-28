import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sizer/sizer.dart';
import '../controller/admin_passcode_controller.dart';

class AdminPassCodeView extends GetView<AdminPassCodeController> {
  const AdminPassCodeView({super.key});
// 9199032452
  @override
  Widget build(BuildContext context) {
    Get.put(AdminPassCodeController());
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Verification Code",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            "Please type the passcode",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
          ),
          Text(
            "for the Admin account",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
          ),
          SizedBox(
            height: 3.h,
          ),
          Container(
            alignment: Alignment.center,
            child: OtpTextField(
              obscureText: true,
              numberOfFields: 6,
              borderColor: Colors.orange,
              disabledBorderColor: Colors.black,
              enabledBorderColor: Colors.orange,
              fillColor: Colors.orange,
              showFieldAsBox: true,
              focusedBorderColor: Colors.white,
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) async {
                controller.checkAdminAccount(code: verificationCode);
              }, // end onSubmit
            ),
          ),
        ],
      ),
    );
  }
}
