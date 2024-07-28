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
          padding: EdgeInsets.only(top: 2.h),
          child: SizedBox(
            height: 100.h,
            width: 100.w,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 7.h,
                        width: 43.w,
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
                      Container(
                        height: 7.h,
                        width: 43.w,
                        decoration: BoxDecoration(
                            color: AppColors.light,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8)),
                        child: Obx(
                          () => DropdownButton<String>(
                            value: controller.selectedAccountType.value,
                            padding: EdgeInsets.only(
                                left: 5.w, right: 5.w, top: .5.h),
                            underline: const SizedBox(),
                            elevation: 16,
                            isExpanded: true,
                            onChanged: (String? value) {
                              controller.selectedAccountType.value = value!;
                              controller.searchFunction(
                                  keyword: controller.search.text);
                            },
                            items: controller.accountTypeList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Expanded(
                  child: Obx(
                    () => controller.pendingUserList.isEmpty
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
                                    "No pending for approval users.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppFontSizes.regular),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.pendingUserList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                    border: index ==
                                            (controller.pendingUserList.length -
                                                1)
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
                                      child: Text(
                                        controller.pendingUserList[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: AppFontSizes.medium),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.w, right: 5.w),
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
                                      padding: EdgeInsets.only(
                                          left: 5.w, right: 5.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller
                                                            .pendingUserList[
                                                                index]
                                                            .accountType ==
                                                        "Group"
                                                    ? "Company/Group"
                                                    : controller
                                                                .pendingUserList[
                                                                    index]
                                                                .accountType ==
                                                            "Individual"
                                                        ? "Individual/Freelancer"
                                                        : "Client",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize:
                                                        AppFontSizes.regular),
                                              ),
                                              Text(
                                                controller
                                                    .pendingUserList[index]
                                                    .email,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize:
                                                        AppFontSizes.regular),
                                              ),
                                              Text(
                                                controller
                                                    .pendingUserList[index]
                                                    .contactno,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize:
                                                        AppFontSizes.regular),
                                              ),
                                              Text(
                                                controller
                                                    .pendingUserList[index]
                                                    .address,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize:
                                                        AppFontSizes.regular),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    controller.downloadFile(
                                                        link: controller
                                                            .pendingUserList[
                                                                index]
                                                            .documentLink,
                                                        index: index,
                                                        filename: controller
                                                            .pendingUserList[
                                                                index]
                                                            .name);
                                                  },
                                                  icon: const Icon(
                                                      Icons.download)),
                                              Positioned(
                                                child: Obx(
                                                  () => controller
                                                              .pendingUserList[
                                                                  index]
                                                              .isDownloading
                                                              .value ==
                                                          false
                                                      ? const SizedBox()
                                                      : Obx(
                                                          () =>
                                                              CircularPercentIndicator(
                                                            radius: 5.w,
                                                            lineWidth: 1.w,
                                                            animation: true,
                                                            percent: controller
                                                                .pendingUserList[
                                                                    index]
                                                                .progress
                                                                .value,
                                                            circularStrokeCap:
                                                                CircularStrokeCap
                                                                    .round,
                                                            progressColor:
                                                                AppColors
                                                                    .orange,
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
                                      padding: EdgeInsets.only(
                                          left: 5.w, right: 5.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                          .pendingUserList[
                                                              index]
                                                          .id);
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
                                                          .pendingUserList[
                                                              index]
                                                          .id);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
