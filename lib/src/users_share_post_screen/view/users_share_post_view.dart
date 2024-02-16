import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/src/users_share_post_screen/controller/users_share_post_controller.dart';
import 'package:mediatooker/src/users_share_post_screen/widget/users_share_post_video_player_view.dart';
import 'package:sizer/sizer.dart';

class UsersSharePostViewPage extends GetView<UserSharePostController> {
  const UsersSharePostViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserSharePostController());
    return Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.orange,
          backgroundColor: Colors.white,
          title: const Text(
            'Share post',
            style: TextStyle(color: AppColors.dark),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(top: 1.h, bottom: 1.h, right: 5.w),
              child: ElevatedButton(
                  onPressed: () {
                    controller.sharePost();
                  },
                  child: const Text("SHARE")),
            )
          ],
        ),
        body: SizedBox(
          child: SingleChildScrollView(
            child: Column(
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
                            imageUrl: Get.find<StorageServices>()
                                .storage
                                .read('profilePicture'),
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
                                Get.find<StorageServices>()
                                    .storage
                                    .read('name'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSizes.regular,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.textPost.clear();
                        },
                        child: Icon(
                          Icons.clear,
                          color: AppColors.dark,
                          size: 23.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: SizedBox(
                      // color: AppColors.light,
                      height: 25.h,
                      width: 100.w,
                      child: TextField(
                        controller: controller.textPost,
                        maxLines: 15,
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                        ),
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: AppFontSizes.medium,
                            ),
                            hintText: 'Share whats on your mind..',
                            contentPadding:
                                EdgeInsets.only(left: 3.w, top: 2.h),
                            border: InputBorder.none),
                      )),
                ),
                SizedBox(
                  height: 1.h,
                ),
                const Divider(),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Row(
                    children: [
                      Obx(
                        () => CachedNetworkImage(
                          imageUrl: controller.profilePicture.value,
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
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Obx(
                        () => Text(
                          controller.userName.value,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.regular,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Obx(
                    () => Text(
                      controller.originalCaption.value,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: AppFontSizes.regular),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Obx(
                    () => controller.filetype.value == 'video'
                        ? UsersSharePostVideoWidget(url: controller.url.value)
                        : controller.filetype.value == 'image'
                            ? Container(
                                height: 35.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                    color: AppColors.dark,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            controller.url.value))),
                              )
                            : SizedBox(
                                height: 35.h,
                                width: 100.w,
                              ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
