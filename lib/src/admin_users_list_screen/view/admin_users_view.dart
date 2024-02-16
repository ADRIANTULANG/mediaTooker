import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/src/admin_users_list_screen/controller/admin_users_list_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_fontsizes.dart';
import '../../users_profile_screen/view/users_profile_view.dart';

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
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getUsers(),
        child: Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: SizedBox(
            height: 100.h,
            width: 100.w,
            child: Obx(
              () => ListView.builder(
                itemCount: controller.usersList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        border: index == (controller.usersList.length - 1)
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
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    controller.usersList[index].profilePhoto,
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
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => const UsersProfileView(),
                                      arguments: {
                                        "userid": controller.usersList[index].id
                                      });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.usersList[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppFontSizes.medium),
                                    ),
                                    Text(
                                      "${DateFormat.yMMMMd().format(controller.usersList[index].datecreated)} ${DateFormat.jm().format(controller.usersList[index].datecreated)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: AppFontSizes.small),
                                    ),
                                  ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.usersList[index].email,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: AppFontSizes.regular),
                                  ),
                                  Text(
                                    controller.usersList[index].contactno,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: AppFontSizes.regular),
                                  ),
                                  Text(
                                    controller.usersList[index].address,
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
                                                .usersList[index].documentLink,
                                            index: index,
                                            filename: controller
                                                .usersList[index].name);
                                      },
                                      icon: const Icon(Icons.download)),
                                  Positioned(
                                    child: Obx(
                                      () => controller.usersList[index]
                                                  .isDownloading.value ==
                                              false
                                          ? const SizedBox()
                                          : Obx(
                                              () => CircularPercentIndicator(
                                                radius: 5.w,
                                                lineWidth: 1.w,
                                                animation: true,
                                                percent: controller
                                                    .usersList[index]
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
