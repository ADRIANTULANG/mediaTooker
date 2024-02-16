import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/src/users_profile_screen/widget/users_profile_video_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_fontsizes.dart';
import '../controller/users_profile_controller.dart';
import 'users_profile_image_widget.dart';
import 'users_profile_sharedpost_widget.dart';

class UsersProfilePostWidget extends GetView<UsersProfileController> {
  const UsersProfilePostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(
        () => ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.allPost.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                controller.allPost[index].sharerProfilePicture,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 5.5.w,
                              backgroundColor: AppColors.dark,
                              child: CircleAvatar(
                                radius: 5.w,
                                backgroundImage: imageProvider,
                              ),
                            ),
                            placeholder: (context, url) => CircleAvatar(
                              radius: 5.5.w,
                              backgroundColor: AppColors.dark,
                              child: CircleAvatar(
                                radius: 5.w,
                                backgroundColor: AppColors.light,
                              ),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 5.5.w,
                              backgroundColor: AppColors.dark,
                              child: CircleAvatar(
                                radius: 5.w,
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
                                controller.allPost[index].sharerName,
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
                      Icon(
                        Icons.clear,
                        color: AppColors.dark,
                        size: 23.sp,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                controller.allPost[index].textpost == ""
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: Text(
                          controller.allPost[index].textpost,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: AppFontSizes.regular),
                        ),
                      ),
                SizedBox(
                  height: controller.allPost[index].textpost == "" ? 0.h : 1.h,
                ),
                controller.allPost[index].type == "text"
                    ? const SizedBox()
                    : const Divider(),
                controller.allPost[index].isShared
                    ? UsersProfileSharedPostWidget(index: index)
                    : const SizedBox(),
                SizedBox(
                  height: 2.h,
                ),
                controller.allPost[index].type == 'video'
                    ? UsersProfileVideoWidget(
                        index: index,
                        url: controller.allPost[index].url,
                      )
                    : controller.allPost[index].type == 'image'
                        ? UsersProfileImageWidget(index: index)
                        : const SizedBox(),
                SizedBox(
                  height: controller.allPost[index].type == "text" ? 0.h : 1.h,
                ),
                Container(
                  height: 1.h,
                  color: AppColors.light,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
