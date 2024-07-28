import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/src/users_profile_screen/widget/users_profile_video_widget.dart';
import 'package:mediatooker/src/users_share_post_screen/view/users_share_post_view.dart';
import 'package:sizer/sizer.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_fontsizes.dart';
import '../alertdialog/users_profile_alertdialog.dart';
import '../controller/users_profile_controller.dart';
import 'users_profile_image_widget.dart';
import 'users_profile_sharedpost_widget.dart';

class UsersProfilePostWidget extends GetView<UsersProfileController> {
  const UsersProfilePostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(
        () => controller.allPost.isEmpty
            ? SizedBox(
                height: 20.h,
                width: 100.w,
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text(
                    "No available Posts.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.regular),
                  ),
                )),
              )
            : ListView.builder(
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
                                  imageUrl: controller
                                      .allPost[index].sharerProfilePicture,
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
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
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
                            Obx(
                              () => controller.userid.value ==
                                      Get.find<StorageServices>()
                                          .storage
                                          .read('id')
                                  ? Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            UsersProfileAlertDialog
                                                .showEditCaption(
                                                    captionText: controller
                                                            .allPost[index]
                                                            .isShared
                                                        ? controller
                                                            .allPost[index]
                                                            .textpost
                                                        : controller
                                                            .allPost[index]
                                                            .originalUserTextPost,
                                                    captionID: controller
                                                        .allPost[index].id,
                                                    isShared: controller
                                                        .allPost[index]
                                                        .isShared);
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: AppColors.dark,
                                            size: 20.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            UsersProfileAlertDialog
                                                .showDeletePost(
                                                    index: index,
                                                    postID: controller
                                                        .allPost[index].id);
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            color: AppColors.dark,
                                            size: 23.sp,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
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
                        height: controller.allPost[index].textpost == ""
                            ? 0.h
                            : 1.h,
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
                        height: controller.allPost[index].type == "text"
                            ? 0.h
                            : 1.h,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.getComments(
                                    userid: controller.allPost[index].isShared
                                        ? controller.allPost[index].sharerId
                                        : controller.allPost[index].userId,
                                    fcmToken: controller.allPost[index].isShared
                                        ? controller
                                            .allPost[index].sharerFcmToken
                                        : controller
                                            .allPost[index].userFcmToken,
                                    postID: controller.allPost[index].id);
                              },
                              child: Icon(
                                Icons.comment,
                                color: AppColors.orange,
                                size: 23.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Obx(
                              () => controller.allPost[index].isLike.value
                                  ? GestureDetector(
                                      onTap: () {
                                        controller.unlikePost(
                                            index: index,
                                            isLike: controller
                                                .allPost[index].isLike.value);
                                      },
                                      child: Icon(
                                        Icons.thumb_up_rounded,
                                        color: AppColors.orange,
                                        size: 23.sp,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        controller.likePost(
                                            index: index,
                                            isLike: controller
                                                .allPost[index].isLike.value);
                                        controller.sendNotification(
                                            userid: controller
                                                .allPost[index].originalUserId,
                                            fmcToken: controller
                                                .allPost[index].userFcmToken,
                                            action: "like");
                                        if (controller
                                            .allPost[index].isShared) {
                                          controller.sendNotification(
                                              userid: controller
                                                  .allPost[index].sharerId,
                                              fmcToken: controller
                                                  .allPost[index]
                                                  .sharerFcmToken,
                                              action: "shared");
                                        }
                                      },
                                      child: Icon(
                                        Icons.thumb_up_alt_outlined,
                                        color: AppColors.orange,
                                        size: 23.sp,
                                      ),
                                    ),
                            ),
                          ),
                          controller.userid.value ==
                                  Get.find<StorageServices>().storage.read('id')
                              ? const SizedBox.shrink()
                              : Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          () => const UsersSharePostViewPage(),
                                          arguments: {
                                            "filetype":
                                                controller.allPost[index].type,
                                            "url":
                                                controller.allPost[index].url,
                                            "userName":
                                                controller.allPost[index].name,
                                            "profilePicture": controller
                                                .allPost[index].profilePicture,
                                            "postID":
                                                controller.allPost[index].id,
                                            "originalCaption": controller
                                                .allPost[index]
                                                .originalUserTextPost,
                                            "originalUserID": controller
                                                .allPost[index].originalUserId,
                                          });
                                    },
                                    child: Icon(
                                      Icons.ios_share,
                                      color: AppColors.orange,
                                      size: 23.sp,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
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
