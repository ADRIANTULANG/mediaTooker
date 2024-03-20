import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/src/users_project_list_screen/controller/users_project_list_controller.dart';
import 'package:sizer/sizer.dart';

class UsersProjectListAlertDialog {
  static showRateUser({required String userid}) {
    var controller = Get.find<UsersProjectListController>();
    TextEditingController feedback = TextEditingController();
    double selectedRating = 3.0;
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 1.h,
            ),
            Text(
              "Ratings & Feedback",
              style: TextStyle(
                  fontSize: AppFontSizes.large, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2.h,
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                selectedRating = rating;
              },
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 15.h,
              width: 100.w,
              child: TextField(
                controller: feedback,
                style: TextStyle(fontSize: AppFontSizes.regular),
                maxLines: 15,
                decoration: InputDecoration(
                  fillColor: AppColors.light,
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 3.w, top: 2.h),
                  alignLabelWithHint: false,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3)),
                  hintText: 'Say something about this provider..',
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 30.w,
                    child: ElevatedButton(
                        style: const ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll(AppColors.orange),
                            backgroundColor:
                                MaterialStatePropertyAll(AppColors.light)),
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Cancel"))),
                SizedBox(
                    width: 30.w,
                    child: ElevatedButton(
                        onPressed: () {
                          if (feedback.text.isNotEmpty) {
                            controller.rateUser(
                                feedback: feedback.text,
                                userrating: selectedRating,
                                userid: userid);
                          }
                        },
                        child: const Text("Submit"))),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ),
    ));
  }
}
