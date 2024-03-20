import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/src/users_profile_screen/controller/users_profile_controller.dart';
import 'package:sizer/sizer.dart';
import '../../../config/app_colors.dart';

class UsersProfileCommentsBottomSheets {
  static showCommentBottomSheets(
      {required String postid,
      required String fcmToken,
      required String userid}) {
    var controller = Get.find<UsersProfileController>();
    Get.bottomSheet(
        Container(
          // height: isKeyboardVisible ? 30.h : 38.h,
          width: 100.w,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Text(
                    "Comments",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.large),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: SizedBox(
                    height: 60.h,
                    width: 100.w,
                    child: Obx(
                      () => ListView.builder(
                        itemCount: controller.commentList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: controller
                                        .commentList[index].userprofile,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.commentList[index].username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppFontSizes.regular,
                                        ),
                                      ),
                                      Text(
                                        "${DateFormat.yMMMd().format(controller.commentList[index].datecreated)} ${DateFormat.jm().format(controller.commentList[index].datecreated)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: AppFontSizes.small,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                controller.commentList[index].comment,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: AppFontSizes.regular),
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
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 7.h,
                        width: 60.w,
                        child: TextField(
                          style: TextStyle(fontSize: AppFontSizes.regular),
                          controller: controller.commentText,
                          decoration: InputDecoration(
                              fillColor: AppColors.light,
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 3.w),
                              alignLabelWithHint: false,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              hintText: 'Say something here..',
                              hintStyle: const TextStyle(fontFamily: 'Bariol')),
                        ),
                      ),
                      SizedBox(
                        height: 6.3.h,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (controller.commentText.text.isNotEmpty) {
                                controller.saveComments(
                                    postid: postid,
                                    comment: controller.commentText.text);
                                controller.sendNotification(
                                    userid: userid,
                                    fmcToken: fcmToken,
                                    action: "comment");
                              } else {
                                Get.snackbar("Message", "Missing input.",
                                    duration: const Duration(seconds: 3),
                                    backgroundColor: AppColors.orange,
                                    colorText: Colors.white);
                              }
                            },
                            child: Text(
                              "Comment",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSizes.regular),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        isScrollControlled: true);
  }
}
