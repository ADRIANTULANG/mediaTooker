import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:sizer/sizer.dart';

import '../controller/users_book_provider_controller.dart';

class UsersBookProviderView extends GetView<UsersBookProviderController> {
  const UsersBookProviderView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UsersBookProviderController());

    return Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.orange,
          backgroundColor: Colors.white,
          title: const Text(
            'Book Media Provider',
            style: TextStyle(color: AppColors.dark),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(top: 1.h, bottom: 1.h, right: 5.w),
              child: ElevatedButton(
                  onPressed: () {
                    if (controller.message.text.isEmpty ||
                        controller.selectedDateFormated == null ||
                        controller.selectedTimeFormated == null ||
                        controller.projectTitle.text.isEmpty) {
                      Get.snackbar("Message", "Missing input.",
                          duration: const Duration(seconds: 3),
                          backgroundColor: AppColors.orange,
                          colorText: AppColors.light);
                    } else {
                      controller.bookProvider();
                    }
                  },
                  child: const Text("BOOK")),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: Text(
                  "Project Title",
                  style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Container(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                height: 7.h,
                width: 100.w,
                child: TextField(
                  controller: controller.projectTitle,
                  style: TextStyle(fontSize: AppFontSizes.regular),
                  decoration: InputDecoration(
                      fillColor: AppColors.light,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 3.w),
                      alignLabelWithHint: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Title',
                      hintStyle: const TextStyle(fontFamily: 'Bariol')),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: Text(
                  "Date",
                  style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: InkWell(
                  onTap: () {
                    controller.getDate();
                  },
                  child: Container(
                    height: 6.3.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: AppColors.light,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.w, top: 2.h),
                      child: Obx(() => Text(controller.selectedDate.value)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: Text(
                  "Time",
                  style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: InkWell(
                  onTap: () {
                    controller.getTime();
                  },
                  child: Container(
                    height: 6.3.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: AppColors.light,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.w, top: 2.h),
                      child: Obx(() => Text(controller.selectedTime.value)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: Text(
                  "Message",
                  style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: Container(
                    color: AppColors.light,
                    height: 40.h,
                    width: 100.w,
                    child: TextField(
                      controller: controller.message,
                      maxLines: 25,
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                      ),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: AppFontSizes.medium,
                          ),
                          hintText: 'Describe your project..',
                          contentPadding: EdgeInsets.only(left: 3.w, top: 2.h),
                          border: InputBorder.none),
                    )),
              ),
            ],
          ),
        ));
  }
}
