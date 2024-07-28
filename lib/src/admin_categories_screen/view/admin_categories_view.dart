import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/src/login_users_and_admin_screen/view/login_users_and_admin_view.dart';
import 'package:sizer/sizer.dart';
import '../../../config/app_fontsizes.dart';
import '../../../services/loading_dialog.dart';
import '../controller/admin_categories_controller.dart';
import '../dialog/admin_categories_dialog.dart';

class AdminCategoriesView extends GetView<AdminCategoriesController> {
  const AdminCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: const Text(
            "Categories",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () async {
                LoadingDialog.showLoadingDialog();
                Timer(const Duration(seconds: 3), () async {
                  Get.find<StorageServices>().removeStorageCredentials();
                  Get.offAll(() => const LoginView());
                });
              },
              child: Icon(
                Icons.power_settings_new_rounded,
                color: AppColors.light,
                size: 23.sp,
              ),
            ),
            SizedBox(
              width: 5.w,
            )
          ],
        ),
        body: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 7.h,
                      width: 68.w,
                      child: TextField(
                        controller: controller.search,
                        style: TextStyle(fontSize: AppFontSizes.regular),
                        onChanged: (value) {
                          if (controller.debouncer?.isActive ?? false) {
                            controller.debouncer?.cancel();
                          }
                          controller.debouncer =
                              Timer(const Duration(milliseconds: 500), () {
                            controller.searchFunction(keyword: value);
                          });
                        },
                        decoration: InputDecoration(
                            fillColor: AppColors.light,
                            filled: true,
                            alignLabelWithHint: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Search',
                            hintStyle: const TextStyle(fontFamily: 'Bariol')),
                      ),
                    ),
                    SizedBox(
                      height: 7.h,
                      child: ElevatedButton(
                          onPressed: () {
                            AdminCategoriesDialog.showAddCategory();
                          },
                          child: const Icon(Icons.add)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                child: Obx(
                  () => controller.categoriesList.isEmpty
                      ? SizedBox(
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
                                  "No available categories.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppFontSizes.regular),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.categoriesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 5.w, right: 5.w, bottom: 2.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.categoriesList[index].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppFontSizes.medium),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            AdminCategoriesDialog.showEditName(
                                                oldname: controller
                                                    .categoriesList[index].name,
                                                docid: controller
                                                    .categoriesList[index].id);
                                          },
                                          icon: const Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            AdminCategoriesDialog
                                                .showDeleteCategory(
                                                    docId: controller
                                                        .categoriesList[index]
                                                        .id);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ));
  }
}
