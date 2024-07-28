import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:sizer/sizer.dart';

import '../../users_profile_screen/view/users_profile_view.dart';
import '../controller/users_feedback_and_rating_controller.dart';

class UsersFeedbackAndRatingPage
    extends GetView<UsersFeedbackAndRatingController> {
  const UsersFeedbackAndRatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UsersFeedbackAndRatingController());
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
      height: 100.h,
      width: 100.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "Ratings & Feedback",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.extraLarge),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Row(
              children: [
                Text(
                  "Ratings count ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.regular),
                ),
                Obx(
                  () => Text(
                    controller.ratingCount.value,
                    style: TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.regular),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Row(
              children: [
                Text(
                  "Average ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.regular),
                ),
                Obx(
                  () => Text(
                    controller.ratingsAverage.value,
                    style: TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.regular),
                  ),
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 15.sp,
                )
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          const Divider(),
          Expanded(
            child: Obx(
              () => controller.ratingAndFeedbackList.isEmpty
                  ? const SizedBox(
                      child: Center(
                        child: Text("No feedbacks & rating available."),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.ratingAndFeedbackList.length,
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
                                        imageUrl: controller
                                            .ratingAndFeedbackList[index]
                                            .userimage,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 6.5.w,
                                          backgroundColor: AppColors.dark,
                                          child: CircleAvatar(
                                            radius: 6.w,
                                            backgroundImage: imageProvider,
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CircleAvatar(
                                          radius: 6.5.w,
                                          backgroundColor: AppColors.dark,
                                          child: CircleAvatar(
                                            radius: 6.w,
                                            backgroundColor: AppColors.light,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                          radius: 6.5.w,
                                          backgroundColor: AppColors.dark,
                                          child: CircleAvatar(
                                            radius: 6.w,
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
                                                        .ratingAndFeedbackList[
                                                            index]
                                                        .userid
                                                  });
                                            },
                                            child: Text(
                                              controller
                                                  .ratingAndFeedbackList[index]
                                                  .username,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: AppFontSizes.regular,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Project Title:  ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      AppFontSizes.regular,
                                                ),
                                              ),
                                              Text(
                                                controller
                                                    .ratingAndFeedbackList[
                                                        index]
                                                    .projectName,
                                                style: TextStyle(
                                                  color: AppColors.orange,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      AppFontSizes.regular,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "${DateFormat.yMMMd().format(controller.ratingAndFeedbackList[index].datecreated)} ${DateFormat.jm().format(controller.ratingAndFeedbackList[index].datecreated)}",
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
                                      Text(
                                        controller.ratingAndFeedbackList[index]
                                            .rating,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: AppFontSizes.regular),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 17.sp,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.w, right: 5.w),
                              child: Text(
                                controller
                                    .ratingAndFeedbackList[index].feedback,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: AppFontSizes.regular),
                              ),
                            ),
                            controller.ratingAndFeedbackList[index].replies
                                    .isEmpty
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(left: 15.w, right: 5.w),
                                    child: TextButton(
                                        onPressed: () {
                                          controller
                                              .ratingAndFeedbackList[index]
                                              .isReplying
                                              .value = controller
                                                  .ratingAndFeedbackList[index]
                                                  .isReplying
                                                  .value
                                              ? false
                                              : true;
                                          controller.isReplying.value =
                                              controller
                                                  .ratingAndFeedbackList[index]
                                                  .isReplying
                                                  .value;

                                          controller.ratingAndFeedbackID
                                              .value = controller
                                                  .ratingAndFeedbackList[index]
                                                  .isReplying
                                                  .value
                                              ? controller
                                                  .ratingAndFeedbackList[index]
                                                  .id
                                              : "";
                                          log(controller
                                              .ratingAndFeedbackID.value);

                                          for (var i = 0;
                                              i <
                                                  controller
                                                      .ratingAndFeedbackList
                                                      .length;
                                              i++) {
                                            if (i != index) {
                                              controller
                                                  .ratingAndFeedbackList[i]
                                                  .isReplying
                                                  .value = false;
                                            }
                                          }
                                        },
                                        child: Obx(
                                          () => Text(controller
                                                  .ratingAndFeedbackList[index]
                                                  .isReplying
                                                  .value
                                              ? "Cancel"
                                              : "Reply"),
                                        )),
                                  )
                                : SizedBox(
                                    height: 2.h,
                                  ),
                            Padding(
                              padding: EdgeInsets.only(left: 18.w, right: 5.w),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller
                                    .ratingAndFeedbackList[index]
                                    .replies
                                    .length,
                                itemBuilder:
                                    (BuildContext context, int replyindex) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: (replyindex ==
                                                (controller
                                                        .ratingAndFeedbackList[
                                                            index]
                                                        .replies
                                                        .length -
                                                    1))
                                            ? 0
                                            : 2.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: controller
                                                  .ratingAndFeedbackList[index]
                                                  .replies[replyindex]
                                                  .image,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      CircleAvatar(
                                                radius: 6.5.w,
                                                backgroundColor: AppColors.dark,
                                                child: CircleAvatar(
                                                  radius: 6.w,
                                                  backgroundImage:
                                                      imageProvider,
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  CircleAvatar(
                                                radius: 6.5.w,
                                                backgroundColor: AppColors.dark,
                                                child: CircleAvatar(
                                                  radius: 6.w,
                                                  backgroundColor:
                                                      AppColors.light,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CircleAvatar(
                                                radius: 6.5.w,
                                                backgroundColor: AppColors.dark,
                                                child: CircleAvatar(
                                                  radius: 6.w,
                                                  backgroundColor:
                                                      AppColors.light,
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
                                                              .ratingAndFeedbackList[
                                                                  index]
                                                              .replies[
                                                                  replyindex]
                                                              .userid
                                                        });
                                                  },
                                                  child: Text(
                                                    controller
                                                        .ratingAndFeedbackList[
                                                            index]
                                                        .replies[replyindex]
                                                        .name,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          AppFontSizes.regular,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${DateFormat.yMMMd().format(controller.ratingAndFeedbackList[index].replies[replyindex].datecreated)} ${DateFormat.jm().format(controller.ratingAndFeedbackList[index].replies[replyindex].datecreated)}",
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize:
                                                        AppFontSizes.small,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.w, right: 5.w),
                                          child: Text(
                                            controller
                                                .ratingAndFeedbackList[index]
                                                .replies[replyindex]
                                                .replymessage,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: AppFontSizes.regular),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            controller.ratingAndFeedbackList[index].replies
                                    .isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 28.5.w, right: 5.w),
                                    child: TextButton(
                                        onPressed: () {
                                          controller
                                              .ratingAndFeedbackList[index]
                                              .isReplying
                                              .value = controller
                                                  .ratingAndFeedbackList[index]
                                                  .isReplying
                                                  .value
                                              ? false
                                              : true;
                                          controller.isReplying.value =
                                              controller
                                                  .ratingAndFeedbackList[index]
                                                  .isReplying
                                                  .value;

                                          controller.ratingAndFeedbackID
                                              .value = controller
                                                  .ratingAndFeedbackList[index]
                                                  .isReplying
                                                  .value
                                              ? controller
                                                  .ratingAndFeedbackList[index]
                                                  .id
                                              : "";
                                          log(controller
                                              .ratingAndFeedbackID.value);

                                          for (var i = 0;
                                              i <
                                                  controller
                                                      .ratingAndFeedbackList
                                                      .length;
                                              i++) {
                                            if (i != index) {
                                              controller
                                                  .ratingAndFeedbackList[i]
                                                  .isReplying
                                                  .value = false;
                                            }
                                          }
                                        },
                                        child: Obx(
                                          () => Text(controller
                                                  .ratingAndFeedbackList[index]
                                                  .isReplying
                                                  .value
                                              ? "Cancel"
                                              : "Reply"),
                                        )),
                                  )
                                : const SizedBox(),
                          ],
                        );
                      },
                    ),
            ),
          ),
          Obx(() => controller.isReplying.value
              ? Container(
                  height: 11.h,
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        spreadRadius: 3,
                        offset: Offset(1, 2))
                  ]),
                  padding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 6.h,
                        width: 80.w,
                        child: TextField(
                          controller: controller.message,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 3.w),
                              alignLabelWithHint: false,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              hintText: 'Type something..'),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            if (controller.message.text.isNotEmpty) {
                              controller.replyToFeedback(
                                  message: controller.message.text);
                              controller.message.clear();
                              controller.isReplying.value = false;
                              controller.ratingAndFeedbackID.value = '';
                            }
                          },
                          child: const Icon(Icons.send))
                    ],
                  ),
                )
              : const SizedBox()),
        ],
      ),
    )));
  }
}
