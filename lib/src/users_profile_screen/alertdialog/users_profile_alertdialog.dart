import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/src/users_profile_screen/controller/users_profile_controller.dart';
import 'package:sizer/sizer.dart';
import '../../../config/app_colors.dart';

class UsersProfileAlertDialog {
  static showEditName({required String oldname}) {
    TextEditingController name = TextEditingController(text: oldname);
    var controller = Get.find<UsersProfileController>();
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
              "Edit Name",
              style: TextStyle(
                  fontSize: AppFontSizes.large, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 7.h,
              width: 100.w,
              child: TextField(
                controller: name,
                style: TextStyle(fontSize: AppFontSizes.regular),
                decoration: InputDecoration(
                    fillColor: AppColors.light,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 3.w),
                    alignLabelWithHint: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: 'Name',
                    hintStyle: const TextStyle(fontFamily: 'Bariol')),
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
                          if (name.text == oldname) {
                            Get.back();
                          } else if (name.text.isNotEmpty) {
                            controller.editName(newname: name.text);
                          }
                        },
                        child: const Text("Save"))),
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

  static showReportDetails(
      {required String userID,
      required String name,
      required String image,
      required String email}) {
    TextEditingController description = TextEditingController();
    var controller = Get.find<UsersProfileController>();
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
              "Describe why you want to report this user.",
              style: TextStyle(
                  fontSize: AppFontSizes.medium, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 21.h,
              width: 100.w,
              child: TextField(
                controller: description,
                style: TextStyle(fontSize: AppFontSizes.regular),
                maxLines: 10,
                decoration: InputDecoration(
                    fillColor: AppColors.light,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 3.w, top: 2.h),
                    alignLabelWithHint: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: 'Say something about this user..',
                    hintStyle: const TextStyle(fontFamily: 'Bariol')),
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
                          if (description.text.isEmpty) {
                          } else if (description.text.isNotEmpty) {
                            controller.reportUser(
                                userID: userID,
                                name: name,
                                image: image,
                                description: description.text,
                                email: email);
                          }
                        },
                        child: const Text("Report"))),
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

  static showEditDetails(
      {required String oldcontact, required String oldAddress}) {
    TextEditingController address = TextEditingController(text: oldAddress);
    TextEditingController contactno = TextEditingController(text: oldcontact);

    var controller = Get.find<UsersProfileController>();
    for (var i = 0; i < controller.userCategories.length; i++) {
      for (var x = 0; x < controller.categoriesList.length; x++) {
        if (controller.userCategories[i] == controller.categoriesList[x].name) {
          controller.categoriesList[x].isSelected.value = true;
        }
      }
    }

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
              "Edit Details",
              style: TextStyle(
                  fontSize: AppFontSizes.large, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 7.h,
              width: 100.w,
              child: TextField(
                controller: address,
                style: TextStyle(fontSize: AppFontSizes.regular),
                decoration: InputDecoration(
                    fillColor: AppColors.light,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 3.w),
                    alignLabelWithHint: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: 'Address',
                    hintStyle: const TextStyle(fontFamily: 'Bariol')),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 7.h,
              width: 100.w,
              child: TextField(
                controller: contactno,
                style: TextStyle(fontSize: AppFontSizes.regular),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (contactno.text.isEmpty) {
                  } else {
                    if (contactno.text[0] != "9" ||
                        contactno.text.length > 10) {
                      contactno.clear();
                    } else {}
                  }
                },
                decoration: InputDecoration(
                    fillColor: AppColors.light,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 3.w),
                    alignLabelWithHint: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: 'Contact no.',
                    hintStyle: const TextStyle(fontFamily: 'Bariol')),
              ),
            ),
            Obx(
              () => controller.usertype.value == "Client"
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Categories",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.regular,
                          ),
                        ),
                        SizedBox(
                          height: .5.h,
                        ),
                        SizedBox(
                          height: 9.h,
                          width: 100.w,
                          child: Obx(
                            () => ListView.builder(
                              itemCount: controller.categoriesList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: index == 0 ? 1.w : 0.w,
                                      right: 2.w,
                                      top: 1.h,
                                      bottom: 1.h),
                                  child: Obx(
                                    () => ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: controller
                                                    .categoriesList[index]
                                                    .isSelected
                                                    .value
                                                ? const Color(0xffFF6F00)
                                                : const Color(0xfffff0e6)),
                                        onPressed: () {
                                          if (controller.categoriesList[index]
                                                  .isSelected.value ==
                                              false) {
                                            int count = 0;
                                            for (var i = 0;
                                                i <
                                                    controller
                                                        .categoriesList.length;
                                                i++) {
                                              if (controller.categoriesList[i]
                                                  .isSelected.value) {
                                                count++;
                                              }
                                            }
                                            if (count < 3) {
                                              controller.categoriesList[index]
                                                  .isSelected.value = controller
                                                      .categoriesList[index]
                                                      .isSelected
                                                      .value
                                                  ? false
                                                  : true;
                                            } else {
                                              Get.snackbar("Message",
                                                  "You can only select three categories",
                                                  backgroundColor:
                                                      AppColors.orange,
                                                  colorText: AppColors.light);
                                            }
                                          } else {
                                            controller.categoriesList[index]
                                                .isSelected.value = controller
                                                    .categoriesList[index]
                                                    .isSelected
                                                    .value
                                                ? false
                                                : true;
                                          }
                                        },
                                        child: Obx(
                                          () => Text(
                                            controller
                                                .categoriesList[index].name,
                                            style: TextStyle(
                                                color: controller
                                                        .categoriesList[index]
                                                        .isSelected
                                                        .value
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        )),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
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
                          if (address.text.isEmpty || contactno.text.isEmail) {
                            Get.snackbar("Message", "Missing input.",
                                duration: const Duration(seconds: 3),
                                backgroundColor: AppColors.orange,
                                colorText: Colors.white);
                          } else if (contactno.text.length != 10) {
                            Get.snackbar("Message", "Invalid contact no.",
                                duration: const Duration(seconds: 3),
                                backgroundColor: AppColors.orange,
                                colorText: Colors.white);
                          } else {
                            if (controller.usertype.value != "Client") {
                              List<String> selectedCategories = <String>[];
                              for (var i = 0;
                                  i < controller.categoriesList.length;
                                  i++) {
                                if (controller
                                    .categoriesList[i].isSelected.value) {
                                  selectedCategories
                                      .add(controller.categoriesList[i].name);
                                }
                              }
                              if (selectedCategories.isNotEmpty) {
                                controller.editDetails(
                                    updatedcategories: selectedCategories,
                                    newcontact: contactno.text,
                                    newaddress: address.text);
                              } else {
                                Get.snackbar("Message",
                                    "Please select at least one category.",
                                    duration: const Duration(seconds: 3),
                                    backgroundColor: AppColors.orange,
                                    colorText: Colors.white);
                              }
                            } else {
                              controller.editDetails(
                                  updatedcategories: <String>[],
                                  newcontact: contactno.text,
                                  newaddress: address.text);
                            }
                          }
                        },
                        child: const Text("Save"))),
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

  static showEditBio({required String oldBio}) {
    TextEditingController bio = TextEditingController(text: oldBio);
    var controller = Get.find<UsersProfileController>();
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
              "Edit Bio",
              style: TextStyle(
                  fontSize: AppFontSizes.large, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 20.h,
              width: 100.w,
              child: TextField(
                controller: bio,
                maxLines: 15,
                style: TextStyle(fontSize: AppFontSizes.regular),
                decoration: InputDecoration(
                    fillColor: AppColors.light,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 3.w, top: 2.h),
                    alignLabelWithHint: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2)),
                    hintText: 'Describe your self...',
                    hintStyle: const TextStyle(fontFamily: 'Bariol')),
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
                          if (bio.text == oldBio) {
                            Get.back();
                          } else if (bio.text.isNotEmpty) {
                            controller.editBio(newbio: bio.text);
                          }
                        },
                        child: const Text("Save"))),
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

  static showDeletePost({required String postID, required int index}) {
    // TextEditingController bio = TextEditingController(text: oldBio);
    var controller = Get.find<UsersProfileController>();
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
              "Are you sure you want to delete this post? All the comments and likes will be lost.",
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
                          controller.deletePost(postID: postID, index: index);
                        },
                        child: const Text("Delete"))),
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

  static showEditCaption(
      {required String captionText,
      required String captionID,
      required bool isShared}) {
    TextEditingController caption = TextEditingController(text: captionText);
    var controller = Get.find<UsersProfileController>();
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
              "Edit Caption.",
              style: TextStyle(
                  fontSize: AppFontSizes.large, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 20.h,
              width: 100.w,
              child: TextField(
                controller: caption,
                maxLines: 15,
                style: TextStyle(fontSize: AppFontSizes.regular),
                decoration: InputDecoration(
                    fillColor: AppColors.light,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 3.w, top: 2.h),
                    alignLabelWithHint: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2)),
                    hintText: 'Say something about the post...',
                    hintStyle: const TextStyle(fontFamily: 'Bariol')),
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
                          // if (bio.text == oldBio) {
                          //   Get.back();
                          // } else if (bio.text.isNotEmpty) {
                          //   controller.editBio(newbio: bio.text);
                          // }
                          controller.editCaption(
                              captionID: captionID,
                              caption: caption.text,
                              isShared: isShared);
                        },
                        child: const Text("Edit"))),
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
