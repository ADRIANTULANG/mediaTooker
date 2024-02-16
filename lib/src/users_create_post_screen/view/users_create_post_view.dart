import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/src/users_create_post_screen/widget/users_create_post_video_player.dart';
import 'package:sizer/sizer.dart';
import '../../../services/getstorage_services.dart';
import '../controller/users_create_post_controller.dart';

class UsersCreatePostView extends GetView<UserCreatePostController> {
  const UsersCreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserCreatePostController());
    return Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.orange,
          backgroundColor: Colors.white,
          title: const Text(
            'Create post',
            style: TextStyle(color: AppColors.dark),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(top: 1.h, bottom: 1.h, right: 5.w),
              child: ElevatedButton(
                  onPressed: () {
                    if (controller.textPost.text.isEmpty &&
                        controller.filepath.value == "") {
                      Get.snackbar(
                          "Message", "Please add caption, image or video.",
                          duration: const Duration(seconds: 3),
                          backgroundColor: AppColors.orange,
                          colorText: Colors.white);
                    } else {
                      controller.createPost();
                    }
                  },
                  child: const Text("POST")),
            )
          ],
        ),
        body: SizedBox(
          child: SingleChildScrollView(
            child: Column(
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
                              SizedBox(
                                height: 3.h,
                                child: Obx(
                                  () => ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: controller
                                                  .isPublic.value
                                              ? const MaterialStatePropertyAll(
                                                  AppColors.orange)
                                              : const MaterialStatePropertyAll(
                                                  AppColors.light)),
                                      onPressed: () {
                                        controller.isPublic.value =
                                            controller.isPublic.value
                                                ? false
                                                : true;
                                      },
                                      child: Text(
                                        "Public",
                                        style: TextStyle(
                                          color: AppColors.dark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppFontSizes.small,
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.clearAll();
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
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Obx(() => controller.isWithFile.value == false
                      ? SizedBox(
                          height: 43.h,
                          width: 100.w,
                        )
                      : ['jpg', 'png', 'jpeg', 'svg', 'bmp']
                              .contains(controller.extension.value)
                          ? Container(
                              height: 43.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                  color: AppColors.dark,
                                  image: DecorationImage(
                                      image: FileImage(
                                          File(controller.filepath.value)))),
                            )
                          : UsersCreatePostVideoWidget(
                              path: controller.filepath.value)),
                ),
                SizedBox(
                  height: 1.h,
                ),
                const Divider(),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.openCamera();
                        },
                        child: Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColors.orange,
                            size: 23.sp,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.pickFile();
                        },
                        child: Center(
                          child: Icon(
                            Icons.image,
                            color: AppColors.orange,
                            size: 23.sp,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
