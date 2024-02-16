import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/services/body_wrapper.dart';
import 'package:sizer/sizer.dart';

import '../controller/users_registration_controller.dart';
import 'users_registration_credentials_view.dart';

class UsersRegistrationView extends GetView<UsersRegistrationViewController> {
  const UsersRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UsersRegistrationViewController());
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
                "Basic Info",
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
                "Type",
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
              child: Container(
                height: 7.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: AppColors.light,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8)),
                child: Obx(
                  () => DropdownButton<String>(
                    value: controller.dropDownValue.value,
                    padding: EdgeInsets.only(left: 5.w, right: 5.w, top: .5.h),
                    underline: const SizedBox(),
                    elevation: 16,
                    isExpanded: true,
                    onChanged: (String? value) {
                      controller.dropDownValue.value = value!;
                    },
                    items: ['Client', 'Media Provider']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Obx(
                () => Text(
                  controller.dropDownValue.value == "Client"
                      ? "Name"
                      : "Group name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSizes.regular,
                  ),
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
                controller: controller.name,
                style: TextStyle(fontSize: AppFontSizes.regular),
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
                "Contact no.",
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
                controller: controller.contactno,
                style: TextStyle(fontSize: AppFontSizes.regular),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (controller.contactno.text.isEmpty) {
                  } else {
                    if (controller.contactno.text[0] != "9" ||
                        controller.contactno.text.length > 10) {
                      controller.contactno.clear();
                    } else {}
                  }
                },
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
                "Address.",
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
                controller: controller.address,
                style: TextStyle(fontSize: AppFontSizes.regular),
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
              height: 4.h,
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
                    if (controller.dropDownValue.value.isEmpty ||
                        controller.contactno.text.isEmpty ||
                        controller.address.text.isEmpty ||
                        controller.name.text.isEmpty) {
                      Get.snackbar("Message", "Missing input.",
                          backgroundColor: AppColors.orange,
                          colorText: AppColors.light);
                    } else if (controller.contactno.text.length != 10) {
                      Get.snackbar("Message", "Invalid contactno.",
                          backgroundColor: AppColors.orange,
                          colorText: AppColors.light);
                    } else {
                      Get.to(() => const UsersRegistrationCredentialsView());
                    }
                  },
                  child: Text("NEXT",
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
