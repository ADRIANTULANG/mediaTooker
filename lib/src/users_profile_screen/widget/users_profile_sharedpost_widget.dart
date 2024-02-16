import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:sizer/sizer.dart';
import '../controller/users_profile_controller.dart';

class UsersProfileSharedPostWidget
    extends GetView<UsersProfileController> {
  const UsersProfileSharedPostWidget({super.key, required this.index});
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
                imageUrl: controller.allPost[index].profilePicture,
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
                  Text(
                    controller.allPost[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.regular,
                    ),
                  ),
                  Text(
                    "${DateFormat.yMMMd().format(controller.allPost[index].datecreated)} ${DateFormat.jm().format(controller.allPost[index].datecreated)}",
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
            controller.allPost[index].originalUserTextPost,
            style: TextStyle(
                fontWeight: FontWeight.normal, fontSize: AppFontSizes.regular),
          ),
        ),
      ],
    );
  }
}
