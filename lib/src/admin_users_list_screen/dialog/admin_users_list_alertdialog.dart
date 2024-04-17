import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_fontsizes.dart';
import '../controller/admin_users_list_controller.dart';

class AdminUsersListAlertDialog {
  static showTerminateOrNot(
      {required String docId, required bool isTerminateOrActivate}) {
    // TextEditingController bio = TextEditingController(text: oldBio);
    var controller = Get.find<AdminUsersListController>();
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
              isTerminateOrActivate == true
                  ? "Are you sure you want to terminate this user?"
                  : "Are you sure you want to activate this account?",
              style: TextStyle(
                  fontSize: AppFontSizes.regular, fontWeight: FontWeight.w500),
            ),
            // SizedBox(
            //   height: 2.h,
            // ),
            // SizedBox(
            //   height: 20.h,
            //   width: 100.w,
            //   child: TextField(
            //     controller: bio,
            //     maxLines: 15,
            //     style: TextStyle(fontSize: AppFontSizes.regular),
            //     decoration: InputDecoration(
            //         fillColor: AppColors.light,
            //         filled: true,
            //         contentPadding: EdgeInsets.only(left: 3.w, top: 2.h),
            //         alignLabelWithHint: false,
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(2)),
            //         hintText: 'Describe your self...',
            //         hintStyle: const TextStyle(fontFamily: 'Bariol')),
            //   ),
            // ),
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
                          // if (bio.text == oldBio) {
                          //   Get.back();
                          // } else if (bio.text.isNotEmpty) {
                          //   controller.editBio(newbio: bio.text);
                          // }
                          // controller.deletePost(postID: postID, index: index);
                          Get.back();
                          controller.editRestriction(
                              docid: docId, boolean: isTerminateOrActivate);
                        },
                        child: Text(isTerminateOrActivate == true
                            ? "Terminate"
                            : "Activate"))),
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
