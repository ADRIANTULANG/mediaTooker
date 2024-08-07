import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/src/users_profile_screen/widget/users_profile_videosmall_widget.dart';
import 'package:sizer/sizer.dart';
import '../controller/users_profile_controller.dart';

class UsersProfileVideoWidget extends GetView<UsersProfileController> {
  const UsersProfileVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Obx(
        () => controller.videoPost.isEmpty
            ? SizedBox(
                height: 20.h,
                width: 100.w,
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text(
                    "No available Videos.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.regular),
                  ),
                )),
              )
            : GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: .5.h,
                    crossAxisSpacing: 1.w),
                itemCount: controller.videoPost.length,
                itemBuilder: (BuildContext context, int index) {
                  return UsersProfileVideoSmallWidget(
                      url: controller.videoPost[index].url, index: index);
                },
              ),
      ),
    );
  }
}
