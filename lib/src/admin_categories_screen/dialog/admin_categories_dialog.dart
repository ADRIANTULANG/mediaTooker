import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/src/admin_categories_screen/controller/admin_categories_controller.dart';
import 'package:sizer/sizer.dart';

import '../../../config/app_colors.dart';

class AdminCategoriesDialog {
  static showEditName({required String oldname, required String docid}) {
    TextEditingController name = TextEditingController(text: oldname);
    var controller = Get.find<AdminCategoriesController>();
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
              "Edit Category",
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
                            controller.editCategory(
                                oldname: oldname,
                                docid: docid,
                                newname: name.text);
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

  static showAddCategory() {
    TextEditingController name = TextEditingController();
    var controller = Get.find<AdminCategoriesController>();
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
              "Add Category",
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
                          if (name.text.isNotEmpty) {
                            controller.addCategory(name: name.text);
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

  static showDeleteCategory({required String docId}) {
    var controller = Get.find<AdminCategoriesController>();
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
              "Are you sure you want to delete this category?",
              style: TextStyle(
                  fontSize: AppFontSizes.regular, fontWeight: FontWeight.w500),
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
                          controller.deleteCategory(docid: docId);
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
}
