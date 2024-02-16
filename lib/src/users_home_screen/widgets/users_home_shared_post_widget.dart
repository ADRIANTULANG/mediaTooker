import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/src/users_home_screen/controller/users_home_controller.dart';
import 'package:mediatooker/src/users_profile_screen/view/users_profile_view.dart';
import 'package:sizer/sizer.dart';

class UsersHomeSharedPostWidget extends GetView<UsersHomeViewController> {
  const UsersHomeSharedPostWidget({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h),
          child: Row(
            children: [
              SizedBox(
                width: 5.w,
              ),
              CachedNetworkImage(
                imageUrl: controller.postList[index].profilePicture,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 4.5.w,
                  backgroundColor: AppColors.dark,
                  child: CircleAvatar(
                    radius: 4.w,
                    backgroundImage: imageProvider,
                  ),
                ),
                placeholder: (context, url) => CircleAvatar(
                  radius: 4.5.w,
                  backgroundColor: AppColors.dark,
                  child: CircleAvatar(
                    radius: 4.w,
                    backgroundColor: AppColors.light,
                  ),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 4.5.w,
                  backgroundColor: AppColors.dark,
                  child: CircleAvatar(
                    radius: 4.w,
                    backgroundColor: AppColors.light,
                  ),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const UsersProfileView(), arguments: {
                        "userid": controller.postList[index].originalUserId
                      });
                    },
                    child: Text(
                      controller.postList[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.regular,
                      ),
                    ),
                  ),
                  Text(
                    "${DateFormat.yMMMd().format(controller.postList[index].datecreated)} ${DateFormat.jm().format(controller.postList[index].datecreated)}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: AppFontSizes.small,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 11.w, right: 5.w),
          child: Text(
            controller.postList[index].originalUserTextPost,
            style: TextStyle(
                fontWeight: FontWeight.normal, fontSize: AppFontSizes.regular),
          ),
        ),
      ],
    );
  }
}
