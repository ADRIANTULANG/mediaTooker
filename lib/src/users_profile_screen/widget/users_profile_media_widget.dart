import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/src/users_profile_screen/widget/users_profile_videosmall_widget.dart';
import 'package:sizer/sizer.dart';
import '../controller/users_profile_controller.dart';

class UsersProfileMediaWidget extends GetView<UsersProfileController> {
  const UsersProfileMediaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Obx(
        () => GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: .5.h, crossAxisSpacing: 1.w),
          itemCount: controller.mediaPost.length,
          itemBuilder: (BuildContext context, int index) {
            return UsersProfileVideoSmallWidget(
                url: controller.mediaPost[index].url, index: index);
          },
        ),
      ),
    );
  }
}
