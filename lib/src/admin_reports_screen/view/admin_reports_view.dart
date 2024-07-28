import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/src/admin_reports_screen/dialog/admin_reports_dialog.dart';
import 'package:mediatooker/src/login_users_and_admin_screen/view/login_users_and_admin_view.dart';
import 'package:sizer/sizer.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_fontsizes.dart';
import '../../../services/loading_dialog.dart';
import '../../users_profile_screen/view/users_profile_view.dart';
import '../controller/admin_reports_controller.dart';

class AdminReportsView extends GetView<AdminReportsController> {
  const AdminReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: const Text(
            "Reports",
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
        body: RefreshIndicator(
          onRefresh: () => controller.getReportedUsers(),
          child: SizedBox(
            height: 100.h,
            width: 100.w,
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                  ),
                  child: SizedBox(
                    height: 7.h,
                    width: 100.w,
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
                ),
                Expanded(
                  child: Obx(
                    () => controller.reportsList.isEmpty
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
                                    "No available reports.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppFontSizes.regular),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.reportsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                    border: index ==
                                            (controller.reportsList.length - 1)
                                        ? null
                                        : const Border(
                                            bottom: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 219, 218, 218)))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.w, right: 5.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: controller
                                                    .reportsList[index].image,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        CircleAvatar(
                                                  radius: 5.5.w,
                                                  backgroundColor:
                                                      AppColors.dark,
                                                  child: CircleAvatar(
                                                    radius: 5.w,
                                                    backgroundImage:
                                                        imageProvider,
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircleAvatar(
                                                  radius: 5.5.w,
                                                  backgroundColor:
                                                      AppColors.dark,
                                                  child: CircleAvatar(
                                                    radius: 5.w,
                                                    backgroundColor:
                                                        AppColors.light,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        CircleAvatar(
                                                  radius: 5.5.w,
                                                  backgroundColor:
                                                      AppColors.dark,
                                                  child: CircleAvatar(
                                                    radius: 5.w,
                                                    backgroundColor:
                                                        AppColors.light,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                      () =>
                                                          const UsersProfileView(),
                                                      arguments: {
                                                        "userid": controller
                                                            .reportsList[index]
                                                            .userid
                                                      });
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                          .reportsList[index]
                                                          .name,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: AppFontSizes
                                                              .medium),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Obx(
                                                () => Text(
                                                  controller.reportsList[index]
                                                          .restricted.value
                                                      ? "Terminated"
                                                      : "Active",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize:
                                                          AppFontSizes.medium),
                                                ),
                                              ),
                                              SizedBox(
                                                width: .5.w,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 3.w),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    bool boolean = controller
                                                            .reportsList[index]
                                                            .restricted
                                                            .value
                                                        ? false
                                                        : true;
                                                    AdminReportsAlertDialog
                                                        .showTerminateOrNot(
                                                            docId: controller
                                                                .reportsList[
                                                                    index]
                                                                .userid,
                                                            isTerminateOrActivate:
                                                                boolean);
                                                  },
                                                  child: Obx(
                                                    () => controller
                                                            .reportsList[index]
                                                            .restricted
                                                            .value
                                                        ? const Icon(
                                                            Icons
                                                                .disabled_by_default_rounded,
                                                            color: Colors.red,
                                                          )
                                                        : const Icon(
                                                            Icons.check_box,
                                                            color: Colors.green,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 7.w, right: 5.w),
                                      child: Text(
                                        controller
                                            .reportsList[index].description,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: AppFontSizes.regular),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 7.w, right: 5.w),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Reported by: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: AppFontSizes.regular),
                                          ),
                                          Text(
                                            controller.reportsList[index]
                                                .reporterName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: AppFontSizes.regular),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 7.w, right: 5.w),
                                      child: Text(
                                        "${DateFormat.yMMMMd().format(controller.reportsList[index].datecreated)} ${DateFormat.jm().format(controller.reportsList[index].datecreated)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: AppFontSizes.small),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.w, right: 5.w),
                                      child: SizedBox(
                                        width: 100.w,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              controller.validateReport(
                                                  reportID: controller
                                                      .reportsList[index].id);
                                            },
                                            child: const Text("Validate")),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
