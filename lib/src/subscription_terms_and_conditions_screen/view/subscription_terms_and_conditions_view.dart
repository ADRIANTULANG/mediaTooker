import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:sizer/sizer.dart';
import '../controller/subscription_terms_and_conditions_controller.dart';

class SubscriptionTermsAndConditionView
    extends GetView<SubscriptionTermsAndConditionsController> {
  const SubscriptionTermsAndConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SubscriptionTermsAndConditionsController());
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
              "Terms & Conditions",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.extraLarge),
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "By subscribing to ${controller.selectedSubscriptionType.value} subscription, you agree to:",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: AppFontSizes.medium),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Eligibility: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.regular),
                ),
                Text(
                  "You must be 18 or older.",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: AppFontSizes.regular),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 1.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Billing: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.regular),
                ),
                Expanded(
                  child: Text(
                    "Subscriptions are billed upon clicking the accept button bellow and are non-refundable.",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: AppFontSizes.regular),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 1.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Usage: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.regular),
                ),
                Expanded(
                  child: Text(
                    "Use the service responsibly and don’t engage in illegal activities..",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: AppFontSizes.regular),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 1.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Changes: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.regular),
                ),
                Expanded(
                  child: Text(
                    "Terms may change; continued use means acceptance..",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
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
              "Contact Us.",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.extraLarge),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "For questions, contact us at:",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: AppFontSizes.medium),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "MediaTooker",
              style: TextStyle(
                  fontWeight: FontWeight.normal, fontSize: AppFontSizes.medium),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "mediatooker@gmail.com",
              style: TextStyle(
                  fontWeight: FontWeight.normal, fontSize: AppFontSizes.medium),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "+639669876789",
              style: TextStyle(
                  fontWeight: FontWeight.normal, fontSize: AppFontSizes.medium),
            ),
          ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "By clicking the accept button you agree to the terms and conditions",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: AppFontSizes.regular),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: SizedBox(
                width: 100.w,
                height: 7.h,
                child: ElevatedButton(
                    onPressed: () {
                      controller.makePayment(
                          amount: controller.amount.value, currency: "PHP");
                    },
                    child: Text(
                      "Accept",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: AppFontSizes.extraLarge),
                    )),
              )),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    )));
  }
}
