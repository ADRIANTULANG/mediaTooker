import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/src/users_create_post_screen/view/users_create_post_view.dart';
import 'package:mediatooker/src/users_profile_screen/view/users_profile_view.dart';
import 'package:sizer/sizer.dart';
import '../../users_share_post_screen/view/users_share_post_view.dart';
import '../controller/users_home_controller.dart';
import '../widgets/users_home_image_widget.dart';
import '../widgets/users_home_shared_post_widget.dart';
import '../widgets/users_home_video_widget.dart';

class UsersHomeView extends GetView<UsersHomeViewController> {
  const UsersHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          child: RefreshIndicator(
            onRefresh: () async {
              controller.refreshView();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CachedNetworkImage(
                          imageUrl: Get.find<StorageServices>()
                              .storage
                              .read('profilePicture'),
                          imageBuilder: (context, imageProvider) =>
                              GestureDetector(
                            onTap: () {
                              Get.to(() => const UsersProfileView(),
                                  arguments: {
                                    "userid": Get.find<StorageServices>()
                                        .storage
                                        .read('id')
                                  });
                            },
                            child: CircleAvatar(
                              radius: 5.5.w,
                              backgroundColor: AppColors.dark,
                              child: CircleAvatar(
                                radius: 5.w,
                                backgroundImage: imageProvider,
                              ),
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
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const UsersCreatePostView(),
                                arguments: {
                                  "filepath": "",
                                  "fileName": "",
                                  "extension": "",
                                });
                          },
                          child: Container(
                            height: 5.h,
                            width: 65.w,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(30),
                                color: AppColors.light),
                            child: Padding(
                              padding: EdgeInsets.only(left: 4.w, top: 1.2.h),
                              child: Text(
                                "Share your thoughts..",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: AppFontSizes.regular,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.pickFile();
                          },
                          child: Icon(
                            Icons.filter,
                            size: 21.sp,
                            color: AppColors.orange,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Container(
                    height: 1.h,
                    color: AppColors.light,
                  ),
                  SizedBox(
                    child: Obx(
                      () => ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.postList.length,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: controller.postList[index]
                                              .sharerProfilePicture,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  CircleAvatar(
                                            radius: 5.5.w,
                                            backgroundColor: AppColors.dark,
                                            child: CircleAvatar(
                                              radius: 5.w,
                                              backgroundImage: imageProvider,
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              CircleAvatar(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                    () =>
                                                        const UsersProfileView(),
                                                    arguments: {
                                                      "userid": controller
                                                          .postList[index]
                                                          .userId
                                                    });
                                              },
                                              child: Text(
                                                controller
                                                    .postList[index].sharerName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      AppFontSizes.regular,
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
                                    Icon(
                                      Icons.clear,
                                      color: AppColors.dark,
                                      size: 23.sp,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    controller.postList[index].textpost == ""
                                        ? 1.h
                                        : 2.h,
                              ),
                              controller.postList[index].textpost == ""
                                  ? const SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.w, right: 5.w),
                                      child: Text(
                                        controller.postList[index].textpost,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: AppFontSizes.regular),
                                      ),
                                    ),
                              SizedBox(
                                height: 1.h,
                              ),
                              controller.postList[index].isShared
                                  ? const Divider()
                                  : const SizedBox(),
                              controller.postList[index].isShared
                                  ? UsersHomeSharedPostWidget(index: index)
                                  : const SizedBox(),
                              SizedBox(
                                height: 2.h,
                              ),
                              controller.postList[index].type == 'video'
                                  ? UsersHomeVideoWidget(
                                      index: index,
                                      url: controller.postList[index].url,
                                    )
                                  : controller.postList[index].type == 'image'
                                      ? UsersHomeImageWidget(index: index)
                                      : const SizedBox(),
                              SizedBox(
                                height:
                                    controller.postList[index].type == "text"
                                        ? 0.h
                                        : 1.h,
                              ),
                              const Divider(),
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.callUser(
                                            contactno:
                                                "+63${controller.postList[index].contactno}");
                                      },
                                      child: Icon(
                                        Icons.call,
                                        color: AppColors.orange,
                                        size: 23.sp,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.getComments(
                                            userid: controller
                                                    .postList[index].isShared
                                                ? controller
                                                    .postList[index].sharerId
                                                : controller
                                                    .postList[index].userId,
                                            fcmToken: controller
                                                    .postList[index].isShared
                                                ? controller.postList[index]
                                                    .sharerFcmToken
                                                : controller.postList[index]
                                                    .userFcmToken,
                                            postID:
                                                controller.postList[index].id);
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
                                      () => controller
                                              .postList[index].isLike.value
                                          ? GestureDetector(
                                              onTap: () {
                                                controller.unlikePost(
                                                    index: index,
                                                    isLike: controller
                                                        .postList[index]
                                                        .isLike
                                                        .value);
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
                                                        .postList[index]
                                                        .isLike
                                                        .value);
                                                controller.sendNotification(
                                                    userid: controller
                                                        .postList[index]
                                                        .originalUserId,
                                                    fmcToken: controller
                                                        .postList[index]
                                                        .userFcmToken,
                                                    action: "like");
                                                if (controller
                                                    .postList[index].isShared) {
                                                  controller.sendNotification(
                                                      userid: controller
                                                          .postList[index]
                                                          .sharerId,
                                                      fmcToken: controller
                                                          .postList[index]
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
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                            () =>
                                                const UsersSharePostViewPage(),
                                            arguments: {
                                              "filetype": controller
                                                  .postList[index].type,
                                              "url": controller
                                                  .postList[index].url,
                                              "userName": controller
                                                  .postList[index].name,
                                              "profilePicture": controller
                                                  .postList[index]
                                                  .profilePicture,
                                              "postID":
                                                  controller.postList[index].id,
                                              "originalCaption": controller
                                                  .postList[index]
                                                  .originalUserTextPost,
                                              "originalUserID": controller
                                                  .postList[index]
                                                  .originalUserId,
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
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
