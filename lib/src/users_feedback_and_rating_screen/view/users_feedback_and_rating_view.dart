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
          Expanded(
            child: Obx(
              () => ListView.builder(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: controller
                                      .ratingAndFeedbackList[index].userimage,
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
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => const UsersProfileView(),
                                            arguments: {
                                              "userid": controller
                                                  .ratingAndFeedbackList[index]
                                                  .userid
                                            });
                                      },
                                      child: Text(
                                        controller.ratingAndFeedbackList[index]
                                            .username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppFontSizes.regular,
                                        ),
                                      ),
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
                                  controller
                                      .ratingAndFeedbackList[index].rating,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: AppFontSizes.regular),
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 17.sp,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: Text(
                          "              ${controller.ratingAndFeedbackList[index].feedback}",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: AppFontSizes.regular),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    )));
  }
}
