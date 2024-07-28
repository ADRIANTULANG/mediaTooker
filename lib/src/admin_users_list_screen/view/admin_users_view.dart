import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/src/admin_users_list_screen/controller/admin_users_list_controller.dart';
import 'package:mediatooker/src/login_users_and_admin_screen/view/login_users_and_admin_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_fontsizes.dart';
import '../../../services/loading_dialog.dart';
import '../../users_profile_screen/view/users_profile_view.dart';
import '../dialog/admin_users_list_alertdialog.dart';

class AdminUsersListView extends GetView<AdminUsersListController> {
  const AdminUsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text(
          "Users",
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
        onRefresh: () => controller.getUsers(),
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
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Row(
                    children: [
                      Text(
                        "Clients: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.medium),
                      ),
                      Obx(
                        () => Text(
                          controller.clientCount.value.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: AppFontSizes.medium),
                        ),
                      ),
                      SizedBox(
                        width: .5.w,
                      ),
                      Icon(
                        Icons.person,
                        size: 15.sp,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        "Media Providers: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.medium),
                      ),
                      Obx(
                        () => Text(
                          controller.mediaProviderCount.value.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: AppFontSizes.medium),
                        ),
                      ),
                      SizedBox(
                        width: .5.w,
                      ),
                      Icon(
                        Icons.group,
                        size: 15.sp,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Expanded(
                  child: Obx(
                    () => controller.usersList.isEmpty
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
                                    "No available users.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppFontSizes.regular),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.usersList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                    border: index ==
                                            (controller.usersList.length - 1)
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
                                                    .usersList[index]
                                                    .profilePhoto,
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
                                                            .usersList[index].id
                                                      });
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          controller
                                                              .usersList[index]
                                                              .name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  AppFontSizes
                                                                      .medium),
                                                        ),
                                                        SizedBox(
                                                          width: 2.w,
                                                        ),
                                                        Text(
                                                          controller
                                                                      .usersList[
                                                                          index]
                                                                      .rating ==
                                                                  null
                                                              ? "0"
                                                              : controller
                                                                  .usersList[
                                                                      index]
                                                                  .rating!,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  AppFontSizes
                                                                      .medium),
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.yellow,
                                                          size: 15.sp,
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                      "${DateFormat.yMMMMd().format(controller.usersList[index].datecreated)} ${DateFormat.jm().format(controller.usersList[index].datecreated)}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: AppFontSizes
                                                              .small),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 3.w),
                                            child: GestureDetector(
                                              onTap: () {
                                                bool boolean = controller
                                                        .usersList[index]
                                                        .restricted
                                                    ? false
                                                    : true;
                                                AdminUsersListAlertDialog
                                                    .showTerminateOrNot(
                                                        docId: controller
                                                            .usersList[index]
                                                            .id,
                                                        isTerminateOrActivate:
                                                            boolean);
                                                // controller.editRestriction(
                                                //     docid: controller.usersList[index].id,
                                                //     boolean: boolean);
                                              },
                                              child: controller.usersList[index]
                                                      .restricted
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
                                          )
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
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.usersList[index]
                                                            .accountType ==
                                                        "Group"
                                                    ? "Company/Group"
                                                    : controller
                                                                .usersList[
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
                                                    .usersList[index].email,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize:
                                                        AppFontSizes.regular),
                                              ),
                                              Text(
                                                controller
                                                    .usersList[index].contactno,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize:
                                                        AppFontSizes.regular),
                                              ),
                                              Text(
                                                controller
                                                    .usersList[index].address,
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
                                                            .usersList[index]
                                                            .documentLink,
                                                        index: index,
                                                        filename: controller
                                                            .usersList[index]
                                                            .name);
                                                  },
                                                  icon: const Icon(
                                                      Icons.download)),
                                              Positioned(
                                                child: Obx(
                                                  () => controller
                                                              .usersList[index]
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
                                                                .usersList[
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
