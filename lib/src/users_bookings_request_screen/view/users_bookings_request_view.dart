import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/src/users_profile_screen/view/users_profile_view.dart';
import 'package:sizer/sizer.dart';
import '../controller/users_booking_request_controller.dart';
import '../dialog/users_bookings_request_dialog.dart';

class UsersBookingRequestView extends GetView<UsersBookingRequestController> {
  const UsersBookingRequestView({super.key});

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
                  controller.searchBooking(word: value.toString());
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
              () => controller.bookingsList.isEmpty
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
                              "No available bookings.",
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
                      itemCount: controller.bookingsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.w, right: 5.w, top: 2.h),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          controller.usertype.value == "Client"
                                              ? controller.bookingsList[index]
                                                  .providerProfilePic
                                              : controller.bookingsList[index]
                                                  .clientProfilePic,
                                      imageBuilder: (context, imageProvider) =>
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
                                                () => const UsersProfileView(),
                                                arguments: {
                                                  "userid": controller
                                                              .usertype.value ==
                                                          "Client"
                                                      ? controller
                                                          .bookingsList[index]
                                                          .providerId
                                                      : controller
                                                          .bookingsList[index]
                                                          .clientId
                                                });
                                          },
                                          child: Text(
                                            controller.usertype.value ==
                                                    "Client"
                                                ? controller.bookingsList[index]
                                                    .providerName
                                                : controller.bookingsList[index]
                                                    .clientName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: AppFontSizes.regular,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${DateFormat.yMMMd().format(controller.bookingsList[index].datecreated)} ${DateFormat.jm().format(controller.bookingsList[index].datecreated)}",
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
                                          .bookingsList[index].projectTitle,
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
                                      "${DateFormat.yMMMMd().format(controller.bookingsList[index].date)} ${DateFormat.jm().format(controller.bookingsList[index].time)}",
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
                                      controller.bookingsList[index].status,
                                      style: TextStyle(
                                          color: controller.bookingsList[index]
                                                      .status ==
                                                  "Pending"
                                              ? AppColors.orange
                                              : controller.bookingsList[index]
                                                          .status ==
                                                      "Ongoing"
                                                  ? Colors.black
                                                  : controller
                                                              .bookingsList[
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
                                            .bookingsList[index].message,
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
                              controller.bookingsList[index].remarks == null
                                  ? const SizedBox()
                                  : controller
                                          .bookingsList[index].remarks!.isEmpty
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
                                                          .bookingsList[index]
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
                              SizedBox(
                                height: 1.h,
                              ),
                              Obx(
                                () => controller.usertype.value == "Client"
                                    ? const SizedBox()
                                    : controller.bookingsList[index].status ==
                                            "Rejected"
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                left: 5.w, right: 5.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 5.h,
                                                  width: 40.w,
                                                  child: ElevatedButton(
                                                      style: const ButtonStyle(
                                                          foregroundColor:
                                                              MaterialStatePropertyAll(
                                                                  AppColors
                                                                      .orange),
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  AppColors
                                                                      .light)),
                                                      onPressed: () {
                                                        UsersBookingListAlertDialog.showRemarksDialog(
                                                            docid: controller
                                                                .bookingsList[
                                                                    index]
                                                                .id,
                                                            controller:
                                                                controller,
                                                            fmcToken: controller
                                                                .bookingsList[
                                                                    index]
                                                                .clientFcmToken,
                                                            userid: controller
                                                                .bookingsList[
                                                                    index]
                                                                .clientId,
                                                            projectName: controller
                                                                .bookingsList[
                                                                    index]
                                                                .projectTitle);
                                                      },
                                                      child:
                                                          const Text("Reject")),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                  width: 40.w,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        controller.acceptProject(
                                                            docid: controller
                                                                .bookingsList[
                                                                    index]
                                                                .id);
                                                        controller.sendNotification(
                                                            remarks: "",
                                                            projectName: controller
                                                                .bookingsList[
                                                                    index]
                                                                .projectTitle,
                                                            fmcToken: controller
                                                                .bookingsList[
                                                                    index]
                                                                .clientFcmToken,
                                                            action: "Accept",
                                                            userid: controller
                                                                .bookingsList[
                                                                    index]
                                                                .clientId);
                                                      },
                                                      child:
                                                          const Text("Accept")),
                                                ),
                                              ],
                                            ),
                                          ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              index == (controller.bookingsList.length - 1)
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
