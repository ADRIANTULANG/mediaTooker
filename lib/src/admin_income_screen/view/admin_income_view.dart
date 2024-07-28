import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/src/admin_income_screen/controller/admin_income_controller.dart';
import 'package:sizer/sizer.dart';

import '../../../services/getstorage_services.dart';
import '../../../services/loading_dialog.dart';
import '../../login_users_and_admin_screen/view/login_users_and_admin_view.dart';
import '../../users_profile_screen/view/users_profile_view.dart';

class AdminIncomeView extends GetView<AdminIncomeController> {
  const AdminIncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: const Text(
            "Income",
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                  ),
                  child: Container(
                    height: 10.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: AppColors.light,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: Text(
                            "Total Income: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSizes.large),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 1.w),
                          child: Obx(
                            () => Text(
                              controller
                                  .formatCurrency(controller.income.value),
                              style: TextStyle(
                                  color: AppColors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSizes.large),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
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
                            value: controller.selectedSubscriptionType.value,
                            padding: EdgeInsets.only(
                                left: 5.w, right: 5.w, top: .5.h),
                            underline: const SizedBox(),
                            elevation: 16,
                            isExpanded: true,
                            onChanged: (String? value) {
                              controller.selectedSubscriptionType.value =
                                  value!;
                              controller.searchFunction(
                                  keyword: controller.search.text);
                            },
                            items: controller.subscriptionList
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
                SizedBox(
                  child: Obx(
                    () => controller.incomeList.isEmpty
                        ? SizedBox(
                            width: 100.w,
                            height: 40.h,
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
                                    "No available payments or transactions.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppFontSizes.regular),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.incomeList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                    border: index ==
                                            (controller.incomeList.length - 1)
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
                                                    .incomeList[index].image,
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
                                                            .incomeList[index]
                                                            .user
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
                                                              .incomeList[index]
                                                              .name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  AppFontSizes
                                                                      .medium),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "${DateFormat.yMMMMd().format(controller.incomeList[index].datecreated)} ${DateFormat.jm().format(controller.incomeList[index].datecreated)}",
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
                                              Row(
                                                children: [
                                                  Text(
                                                    "Email:  ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: AppFontSizes
                                                            .regular),
                                                  ),
                                                  Text(
                                                    controller.incomeList[index]
                                                        .email,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: AppFontSizes
                                                            .regular),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Phone no:  ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: AppFontSizes
                                                            .regular),
                                                  ),
                                                  Text(
                                                    controller.incomeList[index]
                                                        .contactno,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: AppFontSizes
                                                            .regular),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Subscription type:  ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: AppFontSizes
                                                            .regular),
                                                  ),
                                                  Text(
                                                    controller.incomeList[index]
                                                        .subscriptionType,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: AppFontSizes
                                                            .regular),
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  Icon(
                                                    Icons.subscriptions,
                                                    color: controller
                                                                .incomeList[
                                                                    index]
                                                                .subscriptionType ==
                                                            "Bronze"
                                                        ? const Color(
                                                            0xffCD7F32)
                                                        : controller
                                                                    .incomeList[
                                                                        index]
                                                                    .subscriptionType ==
                                                                "Silver"
                                                            ? const Color(
                                                                0xffC0C0C0)
                                                            : const Color(
                                                                0xffFFD700),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Amount:  ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: AppFontSizes
                                                            .regular),
                                                  ),
                                                  Text(
                                                    controller.formatCurrency(
                                                        double.parse(controller
                                                            .incomeList[index]
                                                            .amount)),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors.orange,
                                                        fontSize: AppFontSizes
                                                            .regular),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Booking points:  ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: AppFontSizes
                                                            .regular),
                                                  ),
                                                  Text(
                                                    controller.incomeList[index]
                                                        .bookings
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors.orange,
                                                        fontSize: AppFontSizes
                                                            .regular),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Upload points:  ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: AppFontSizes
                                                            .regular),
                                                  ),
                                                  Text(
                                                    controller.incomeList[index]
                                                        .uploads
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors.orange,
                                                        fontSize: AppFontSizes
                                                            .regular),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Payment ID:  ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: AppFontSizes
                                                              .regular),
                                                    ),
                                                    SizedBox(
                                                      width: 65.w,
                                                      child: Text(
                                                        controller
                                                            .incomeList[index]
                                                            .paymentId
                                                            .toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .orange,
                                                            fontSize:
                                                                AppFontSizes
                                                                    .regular),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                )
              ],
            ),
          ),
        ));
  }
}
