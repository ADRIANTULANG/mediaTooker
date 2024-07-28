import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/services/image_fullview.dart';
import 'package:mediatooker/src/users_feedback_and_rating_screen/view/users_feedback_and_rating_view.dart';
import 'package:sizer/sizer.dart';

import '../../../config/app_colors.dart';
import '../../users_book_provider_screen/view/users_book_provider_view.dart';
import '../alertdialog/users_profile_alertdialog.dart';
import '../controller/users_profile_controller.dart';
import '../widget/users_profile_image_post_widget.dart';
import '../widget/users_profile_project_finished_widget.dart';
import '../widget/users_profile_video_post_widget.dart';
import '../widget/users_profile_post_widget.dart';

class UsersProfileView extends GetView<UsersProfileController> {
  const UsersProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UsersProfileController());
    return Scaffold(
      body: SizedBox(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: Text(
                    controller.responseMessage.value,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: AppFontSizes.medium),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 42.h,
                            width: 100.w,
                          ),
                          CachedNetworkImage(
                            imageUrl: controller.coverPic.value,
                            imageBuilder: (context, imageProvider) =>
                                GestureDetector(
                              onTap: () {
                                if (Get.find<StorageServices>()
                                        .storage
                                        .read('id') ==
                                    controller.userid.value) {
                                  controller.editCoverPic();
                                }
                              },
                              onDoubleTap: () {
                                Get.to(() => ImageFullView(
                                    imageUrl: controller.coverPic.value));
                              },
                              child: Container(
                                height: 35.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: imageProvider)),
                              ),
                            ),
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) =>
                                const SizedBox(),
                          ),
                          Positioned(
                            top: 27.h,
                            left: 5.w,
                            child: CachedNetworkImage(
                              imageUrl: controller.profilePic.value,
                              imageBuilder: (context, imageProvider) =>
                                  GestureDetector(
                                onTap: () {
                                  if (Get.find<StorageServices>()
                                          .storage
                                          .read('id') ==
                                      controller.userid.value) {
                                    controller.editProfilePic();
                                  }
                                },
                                onDoubleTap: () {
                                  Get.to(() => ImageFullView(
                                      imageUrl: controller.profilePic.value));
                                },
                                child: CircleAvatar(
                                  radius: 15.3.w,
                                  backgroundColor: Colors.black,
                                  child: CircleAvatar(
                                    radius: 15.w,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 14.5.w,
                                      backgroundImage: imageProvider,
                                    ),
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const SizedBox(),
                              errorWidget: (context, url, error) =>
                                  const SizedBox(),
                            ),
                          ),
                          Positioned(
                              top: 6.h,
                              left: 85.w,
                              child: Obx(
                                () => Get.find<StorageServices>()
                                                .storage
                                                .read('id') !=
                                            controller.userid.value &&
                                        controller.usertype.value ==
                                            "Media Provider" &&
                                        Get.find<StorageServices>()
                                                .storage
                                                .read('type') ==
                                            "Client"
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(
                                              () =>
                                                  const UsersBookProviderView(),
                                              arguments: {
                                                "userid":
                                                    controller.userid.value
                                              });
                                        },
                                        child: CircleAvatar(
                                          radius: 5.3.w,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            radius: 5.w,
                                            backgroundColor: AppColors.orange,
                                            child: CircleAvatar(
                                              radius: 4.5.w,
                                              backgroundColor: AppColors.light,
                                              child: Icon(
                                                Icons.book,
                                                size: 19.sp,
                                                color: AppColors.orange,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => controller.usertype.value ==
                                          "Media Provider"
                                      ? Row(
                                          children: [
                                            Text(
                                              controller.name.value,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: AppFontSizes.large),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Obx(
                                              () => Text(
                                                controller.rating.value,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        AppFontSizes.medium),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                    () =>
                                                        const UsersFeedbackAndRatingPage(),
                                                    arguments: {
                                                      "userid": controller
                                                          .userid.value
                                                    });
                                                // UsersProfileAlertDialog
                                                //     .showRateUser();
                                              },
                                              child: const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            )
                                          ],
                                        )
                                      : Text(
                                          controller.name.value,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: AppFontSizes.large),
                                        ),
                                ),
                                Text(
                                  controller.email.value,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: AppFontSizes.regular),
                                ),
                                Text(
                                  controller.accountType.value == "Group"
                                      ? "Company/Group"
                                      : controller.accountType.value ==
                                              "Individual"
                                          ? "Individual/Freelancer"
                                          : "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: AppFontSizes.regular),
                                ),
                              ],
                            ),
                            Get.find<StorageServices>().storage.read('id') ==
                                    controller.userid.value
                                ? GestureDetector(
                                    onTap: () {
                                      UsersProfileAlertDialog.showEditName(
                                          oldname: controller.name.value);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: AppColors.orange,
                                      size: 23.sp,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      controller.emailProvider();
                                    },
                                    child: Icon(
                                      Icons.email,
                                      color: AppColors.orange,
                                      size: 23.sp,
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
                        child: Text(
                          "Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppFontSizes.medium),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.usertype.value,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: AppFontSizes.regular),
                                ),
                                // Text(
                                //   "+63${controller.contactNo.value}",
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.normal,
                                //       fontSize: AppFontSizes.regular),
                                // ),
                                Text(
                                  controller.address.value,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: AppFontSizes.regular),
                                ),
                                Obx(
                                  () => controller.usertype.value == 'Client'
                                      ? const SizedBox()
                                      : SizedBox(
                                          width: 80.w,
                                          child: Obx(
                                            () => ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount: controller
                                                  .userCategories.length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: .2.h),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        size: 7.sp,
                                                      ),
                                                      SizedBox(
                                                        width: 1.w,
                                                      ),
                                                      Text(
                                                        controller
                                                                .userCategories[
                                                            index],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize:
                                                                AppFontSizes
                                                                    .regular),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                )
                              ],
                            ),
                            Get.find<StorageServices>().storage.read('id') ==
                                    controller.userid.value
                                ? GestureDetector(
                                    onTap: () async {
                                      await controller.getCategories();
                                      UsersProfileAlertDialog.showEditDetails(
                                          oldcontact:
                                              controller.contactNo.value,
                                          oldAddress: controller.address.value);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: AppColors.orange,
                                      size: 23.sp,
                                    ),
                                  )
                                : const SizedBox(),
                            // GestureDetector(
                            //     onTap: () {
                            //       controller.callProvider();
                            //     },
                            //     child: Icon(
                            //       Icons.call,
                            //       color: AppColors.orange,
                            //       size: 23.sp,
                            //     ),
                            //   ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: Text(
                          "Bio",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppFontSizes.medium),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Obx(
                                () => Text(
                                  controller.bio.value.isEmpty &&
                                          Get.find<StorageServices>()
                                                  .storage
                                                  .read('id') ==
                                              controller.userid.value
                                      ? "Describe yourself..."
                                      : controller.bio.value,
                                  maxLines: 6,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: AppFontSizes.regular),
                                ),
                              ),
                            ),
                            Get.find<StorageServices>().storage.read('id') ==
                                    controller.userid.value
                                ? GestureDetector(
                                    onTap: () {
                                      UsersProfileAlertDialog.showEditBio(
                                          oldBio: controller.bio.value);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: AppColors.orange,
                                      size: 23.sp,
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                      Get.find<StorageServices>().storage.read('id') ==
                              controller.userid.value
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 2.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 5.w, right: 5.w),
                                  child: SizedBox(
                                    width: 100.w,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          UsersProfileAlertDialog
                                              .showReportDetails(
                                                  email: controller.email.value,
                                                  image: controller
                                                      .profilePic.value,
                                                  name: controller.name.value,
                                                  userID:
                                                      controller.userid.value);
                                        },
                                        child: const Text("Report this user.")),
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
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.selectedContentView.value = "Posts";
                              },
                              child: Obx(
                                () => Container(
                                  padding: EdgeInsets.only(
                                      top: 1.h,
                                      bottom: 1.h,
                                      left: 3.w,
                                      right: 3.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: controller
                                                  .selectedContentView.value ==
                                              "Posts"
                                          ? AppColors.light
                                          : null),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Posts",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppFontSizes.regular,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.selectedContentView.value = "Image";
                              },
                              child: Obx(
                                () => Container(
                                  padding: EdgeInsets.only(
                                      top: 1.h,
                                      bottom: 1.h,
                                      left: 3.w,
                                      right: 3.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: controller
                                                  .selectedContentView.value ==
                                              "Image"
                                          ? AppColors.light
                                          : null),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Image",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppFontSizes.regular,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.selectedContentView.value = "Video";
                              },
                              child: Obx(
                                () => Container(
                                  padding: EdgeInsets.only(
                                      top: 1.h,
                                      bottom: 1.h,
                                      left: 3.w,
                                      right: 3.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: controller
                                                  .selectedContentView.value ==
                                              "Video"
                                          ? AppColors.light
                                          : null),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Video",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppFontSizes.regular,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Obx(
                              () => controller.usertype.value == "Client"
                                  ? const SizedBox()
                                  : GestureDetector(
                                      onTap: () {
                                        controller.selectedContentView.value =
                                            "Projects";
                                      },
                                      child: Obx(
                                        () => Container(
                                          padding: EdgeInsets.only(
                                              top: 1.h,
                                              bottom: 1.h,
                                              left: 3.w,
                                              right: 3.w),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: controller
                                                          .selectedContentView
                                                          .value ==
                                                      "Projects"
                                                  ? AppColors.light
                                                  : null),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Projects",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: AppFontSizes.regular,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Obx(
                        () => controller.selectedContentView.value == "Posts"
                            ? Container(
                                height: 1.h,
                                color: AppColors.light,
                              )
                            : const SizedBox(),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Obx(() => controller.selectedContentView.value == "Video"
                          ? const UsersProfileVideoWidget()
                          : controller.selectedContentView.value == "Image"
                              ? const UsersProfileImagePostWidget()
                              : controller.selectedContentView.value == "Posts"
                                  ? const UsersProfilePostWidget()
                                  : const UserProjectFinishedWidget()),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
