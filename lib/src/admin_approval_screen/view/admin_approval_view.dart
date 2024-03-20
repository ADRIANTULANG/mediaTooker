import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/src/admin_approval_screen/controller/admin_approval_controller.dart';
import 'package:mediatooker/src/login_users_and_admin_screen/view/login_users_and_admin_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../config/app_colors.dart';
import '../../../services/loading_dialog.dart';

class AdminApprovalView extends GetView<AdminApprovalController> {
  const AdminApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text(
          "Approval",
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
        onRefresh: () => controller.getPendingUsers(),
        child: Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: SizedBox(
            height: 100.h,
            width: 100.w,
            child: Obx(
              () => ListView.builder(
                itemCount: controller.pendingUserList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        border: index == (controller.pendingUserList.length - 1)
                            ? null
                            : const Border(
                                bottom: BorderSide(
                                    color:
                                        Color.fromARGB(255, 219, 218, 218)))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Text(
                            controller.pendingUserList[index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSizes.medium),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Text(
                            "${DateFormat.yMMMMd().format(controller.pendingUserList[index].datecreated)} ${DateFormat.jm().format(controller.pendingUserList[index].datecreated)}",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: AppFontSizes.small),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.pendingUserList[index].email,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: AppFontSizes.regular),
                                  ),
                                  Text(
                                    controller.pendingUserList[index].contactno,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: AppFontSizes.regular),
                                  ),
                                  Text(
                                    controller.pendingUserList[index].address,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: AppFontSizes.regular),
                                  ),
                                ],
                              ),
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        controller.downloadFile(
                                            link: controller
                                                .pendingUserList[index]
                                                .documentLink,
                                            index: index,
                                            filename: controller
                                                .pendingUserList[index].name);
                                      },
                                      icon: const Icon(Icons.download)),
                                  Positioned(
                                    child: Obx(
                                      () => controller.pendingUserList[index]
                                                  .isDownloading.value ==
                                              false
                                          ? const SizedBox()
                                          : Obx(
                                              () => CircularPercentIndicator(
                                                radius: 5.w,
                                                lineWidth: 1.w,
                                                animation: true,
                                                percent: controller
                                                    .pendingUserList[index]
                                                    .progress
                                                    .value,
                                                circularStrokeCap:
                                                    CircularStrokeCap.round,
                                                progressColor: AppColors.orange,
                                              ),
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 5.h,
                                width: 40.w,
                                child: ElevatedButton(
                                    style: const ButtonStyle(
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                AppColors.orange),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                AppColors.light)),
                                    onPressed: () {
                                      controller.rejectUsers(
                                          docid: controller
                                              .pendingUserList[index].id);
                                    },
                                    child: const Text("Reject")),
                              ),
                              SizedBox(
                                height: 5.h,
                                width: 40.w,
                                child: ElevatedButton(
                                    onPressed: () {
                                      controller.acceptUsers(
                                          docid: controller
                                              .pendingUserList[index].id);
                                    },
                                    child: const Text("Accept")),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
