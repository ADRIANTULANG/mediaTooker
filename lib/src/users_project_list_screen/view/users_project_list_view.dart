import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/src/users_profile_screen/view/users_profile_view.dart';
import 'package:sizer/sizer.dart';
import 'package:badges/badges.dart' as badges;
import '../../../config/app_fontsizes.dart';
import '../../users_chat_screen/view/users_chat_view.dart';
import '../alertdialog/users_project_list_alertdialog.dart';
import '../controller/users_project_list_controller.dart';

class UsersProjectListView extends GetView<UsersProjectListController> {
  const UsersProjectListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          Container(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            height: 7.h,
            width: 100.w,
            child: TextField(
              controller: controller.search,
              onChanged: (value) {
                if (controller.debouncer?.isActive ?? false) {
                  controller.debouncer?.cancel();
                }
                controller.debouncer =
                    Timer(const Duration(milliseconds: 1000), () {
                  controller.searchProject(word: value.toString());
                });
              },
              style: TextStyle(fontSize: AppFontSizes.regular),
              decoration: InputDecoration(
                  fillColor: AppColors.light,
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 6.w),
                  alignLabelWithHint: false,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32)),
                  hintText: 'Search',
                  hintStyle: const TextStyle(fontFamily: 'Bariol')),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            height: 1.h,
            color: AppColors.light,
          ),
          SizedBox(
            child: Obx(
              () => controller.projectList.isEmpty
                  ? SizedBox(
                      width: 100.w,
                      height: 60.h,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 20.h,
                              width: 100.w,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/logo.png'))),
                            ),
                            Text(
                              "No available projects.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSizes.regular),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.projectList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.w, right: 5.w, top: 2.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: controller.usertype.value ==
                                                  "Client"
                                              ? controller.projectList[index]
                                                  .providerProfilePic
                                              : controller.projectList[index]
                                                  .clientProfilePic,
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
                                                                  .usertype
                                                                  .value ==
                                                              "Client"
                                                          ? controller
                                                              .projectList[
                                                                  index]
                                                              .providerId
                                                          : controller
                                                              .projectList[
                                                                  index]
                                                              .clientId
                                                    });
                                              },
                                              child: Text(
                                                controller.usertype.value ==
                                                        "Client"
                                                    ? controller
                                                        .projectList[index]
                                                        .providerName
                                                    : controller
                                                        .projectList[index]
                                                        .clientName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      AppFontSizes.regular,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${DateFormat.yMMMd().format(controller.projectList[index].datecreated)} ${DateFormat.jm().format(controller.projectList[index].datecreated)}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: AppFontSizes.small,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        controller.projectList[index].status ==
                                                "Finished"
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  controller.usertype.value ==
                                                          "Client"
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            UsersProjectListAlertDialog.showRateUser(
                                                                projectName: controller
                                                                    .projectList[
                                                                        index]
                                                                    .projectTitle,
                                                                projectID: controller
                                                                    .projectList[
                                                                        index]
                                                                    .id,
                                                                userid: controller
                                                                    .projectList[
                                                                        index]
                                                                    .providerId);
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .rate_review_rounded,
                                                            color: AppColors
                                                                .orange,
                                                            size: 23.sp,
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      controller.callClient(
                                                          contactNo: controller
                                                                      .usertype
                                                                      .value ==
                                                                  "Client"
                                                              ? controller
                                                                  .projectList[
                                                                      index]
                                                                  .providerContact
                                                              : controller
                                                                  .projectList[
                                                                      index]
                                                                  .clientContact);
                                                    },
                                                    child: Icon(
                                                      Icons.call,
                                                      color: AppColors.orange,
                                                      size: 23.sp,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox.shrink(),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => const UsersChatView(),
                                                arguments: {
                                                  "userid": controller
                                                              .usertype.value ==
                                                          "Client"
                                                      ? controller
                                                          .projectList[index]
                                                          .providerId
                                                      : controller
                                                          .projectList[index]
                                                          .clientId,
                                                  "projectID": controller
                                                      .projectList[index].id,
                                                  "username": controller
                                                              .usertype.value ==
                                                          "Client"
                                                      ? controller
                                                          .projectList[index]
                                                          .providerName
                                                      : controller
                                                          .projectList[index]
                                                          .clientName,
                                                  "profilePic": controller
                                                              .usertype.value ==
                                                          "Client"
                                                      ? controller
                                                          .projectList[index]
                                                          .providerProfilePic
                                                      : controller
                                                          .projectList[index]
                                                          .clientProfilePic,
                                                  "fcmToken": controller
                                                              .usertype.value ==
                                                          "Client"
                                                      ? controller
                                                          .projectList[index]
                                                          .providerFcmToken
                                                      : controller
                                                          .projectList[index]
                                                          .clientFcmToken,
                                                });
                                          },
                                          child: Obx(
                                            () => badges.Badge(
                                              position:
                                                  badges.BadgePosition.topEnd(
                                                      end: -3),
                                              showBadge: controller
                                                              .usertype.value ==
                                                          "Client" &&
                                                      controller
                                                          .projectList[index]
                                                          .isSeenByClient
                                                  ? false
                                                  : controller.usertype.value ==
                                                              "Media Provider" &&
                                                          controller
                                                              .projectList[
                                                                  index]
                                                              .isSeenByProvider
                                                      ? false
                                                      : true,
                                              badgeContent: Text(
                                                "!",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 7.sp,
                                                    color: AppColors.light),
                                              ),
                                              child: Icon(
                                                Icons.message_rounded,
                                                color: AppColors.orange,
                                                size: 23.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              const Divider(),
                              SizedBox(
                                height: 1.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "Title: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppFontSizes.regular),
                                    ),
                                    Text(
                                      controller
                                          .projectList[index].projectTitle,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppFontSizes.regular),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "Date & Time: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: AppFontSizes.regular),
                                    ),
                                    Text(
                                      "${DateFormat.yMMMMd().format(controller.projectList[index].date)} ${DateFormat.jm().format(controller.projectList[index].time)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: AppFontSizes.regular),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "Status: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: AppFontSizes.regular),
                                    ),
                                    Text(
                                      controller.projectList[index].status,
                                      style: TextStyle(
                                          color: controller.projectList[index]
                                                      .status ==
                                                  "Pending"
                                              ? AppColors.orange
                                              : controller.projectList[index]
                                                          .status ==
                                                      "Ongoing"
                                                  ? Colors.black
                                                  : controller
                                                              .projectList[
                                                                  index]
                                                              .status ==
                                                          "Rejected"
                                                      ? Colors.red
                                                      : Colors.green,
                                          fontWeight: FontWeight.normal,
                                          fontSize: AppFontSizes.regular),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Task:  ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'BariolNormal',
                                            fontWeight: FontWeight.bold,
                                            fontSize: AppFontSizes.regular),
                                      ),
                                      TextSpan(
                                        text: controller
                                            .projectList[index].message,
                                        style: TextStyle(
                                            fontFamily: 'BariolNormal',
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: AppFontSizes.regular),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              controller.projectList[index].remarks == null
                                  ? const SizedBox()
                                  : controller
                                          .projectList[index].remarks!.isEmpty
                                      ? const SizedBox()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5.w, right: 5.w),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "Provider's remarks:  ",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'BariolNormal',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: AppFontSizes
                                                              .regular),
                                                    ),
                                                    TextSpan(
                                                      text: controller
                                                          .projectList[index]
                                                          .remarks!,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'BariolNormal',
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: AppFontSizes
                                                              .regular),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                              SizedBox(
                                height: 1.h,
                              ),
                              const Divider(),
                              Obx(
                                () => controller.usertype.value == "Client"
                                    ? const SizedBox()
                                    : controller.projectList[index].status ==
                                            "Finished"
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                left: 5.w, right: 5.w),
                                            child: SizedBox(
                                              height: 5.h,
                                              width: 100.w,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    UsersProjectListAlertDialog
                                                        .showRemarksDialog(
                                                            docid: controller
                                                                .projectList[
                                                                    index]
                                                                .id,
                                                            controller:
                                                                controller,
                                                            fmcToken: controller
                                                                .projectList[
                                                                    index]
                                                                .clientFcmToken,
                                                            userid: controller
                                                                .projectList[
                                                                    index]
                                                                .clientId,
                                                            projectName: controller
                                                                .projectList[
                                                                    index]
                                                                .projectTitle);
                                                  },
                                                  child: const Text("DONE")),
                                            ),
                                          ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              index == (controller.projectList.length - 1)
                                  ? const SizedBox(
                                      height: 1,
                                    )
                                  : Container(
                                      height: 1.h,
                                      color: AppColors.light,
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    )));
  }
}
