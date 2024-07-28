import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/src/subscription_terms_and_conditions_screen/view/subscription_terms_and_conditions_view.dart';
import 'package:sizer/sizer.dart';

import '../../../config/app_fontsizes.dart';
import '../controller/user_subscription_controller.dart';

class UserSubscriptionView extends GetView<UserSubscriptionController> {
  const UserSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserSubscriptionController());

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
              "Subscription",
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
                  "Current subscription: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.regular),
                ),
                Obx(
                  () => Text(
                    controller.currentSubscription.value.toString(),
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
                  "Remaining bookings: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.regular),
                ),
                Obx(
                  () => Text(
                    controller.currentBooking.value.toString(),
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
                  "Remaining uploads: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.regular),
                ),
                Obx(
                  () => Text(
                    controller.currentUpload.value.toString(),
                    style: TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.regular),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "Select the subscription you want ",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: AppFontSizes.medium),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
            child: SizedBox(
              height: 22.h,
              width: 100.w,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    Get.to(() => const SubscriptionTermsAndConditionView(),
                        arguments: {
                          "type": "Bronze",
                          "bookings": 20,
                          "uploads": 20,
                          "amount": "40",
                        });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Row(
                          children: [
                            Text(
                              "Bronze ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: AppFontSizes.extraLarge),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Icon(
                              Icons.subscriptions,
                              size: 25.sp,
                              color: const Color(0xffCD7F32),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          "40 Php. ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: AppFontSizes.medium),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          "With bronze subscription you can enjoy 20 uploads and 20 bookings. ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: AppFontSizes.medium),
                        ),
                      ),
                      SizedBox(
                        height: .5.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          "(Note: Bookings and Uploads can be stacked every time you subscribe.). ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: AppFontSizes.regular),
                        ),
                      )
                    ],
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
            child: SizedBox(
              height: 22.h,
              width: 100.w,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    Get.to(() => const SubscriptionTermsAndConditionView(),
                        arguments: {
                          "type": "Silver",
                          "bookings": 40,
                          "uploads": 40,
                          "amount": "80",
                        });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Row(
                          children: [
                            Text(
                              "Silver ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: AppFontSizes.extraLarge),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Icon(
                              Icons.subscriptions,
                              size: 25.sp,
                              color: const Color(0xffC0C0C0),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          "80 Php. ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: AppFontSizes.medium),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          "With Silver subscription you can enjoy 40 uploads and 40 bookings. ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: AppFontSizes.medium),
                        ),
                      ),
                      SizedBox(
                        height: .5.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          "(Note: Bookings and Uploads can be stacked every time you subscribe.). ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: AppFontSizes.regular),
                        ),
                      )
                    ],
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
            child: SizedBox(
              height: 22.h,
              width: 100.w,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    Get.to(() => const SubscriptionTermsAndConditionView(),
                        arguments: {
                          "type": "Gold",
                          "bookings": 80,
                          "uploads": 80,
                          "amount": "160",
                        });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Row(
                          children: [
                            Text(
                              "Gold ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: AppFontSizes.extraLarge),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Icon(
                              Icons.subscriptions,
                              size: 25.sp,
                              color: const Color(0xffFFD700),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          "160 Php. ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: AppFontSizes.medium),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          "With Gold subscription you can enjoy 80 uploads and 80 bookings. ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: AppFontSizes.medium),
                        ),
                      ),
                      SizedBox(
                        height: .5.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          "(Note: Bookings and Uploads can be stacked every time you subscribe.). ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: AppFontSizes.regular),
                        ),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    )));
  }
}
