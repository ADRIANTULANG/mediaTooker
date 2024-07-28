import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:sizer/sizer.dart';
import '../controller/users_profile_controller.dart';

class UserProjectFinishedWidget extends GetView<UsersProfileController> {
  const UserProjectFinishedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(
        () => controller.projectList.isEmpty
            ? SizedBox(
                height: 20.h,
                width: 100.w,
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text(
                    "No available Projects.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.regular),
                  ),
                )),
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.projectList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        controller.usertype.value == "Client"
                                            ? controller.projectList[index]
                                                .providerProfilePic
                                            : controller.projectList[index]
                                                .clientProfilePic,
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
                                      GestureDetector(
                                        onTap: () {
                                          controller.setAnotherUserToView(
                                              newuserid: controller
                                                  .projectList[index].clientId);
                                        },
                                        child: Text(
                                          controller.usertype.value == "Client"
                                              ? controller.projectList[index]
                                                  .providerName
                                              : controller.projectList[index]
                                                  .clientName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: AppFontSizes.regular,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${DateFormat.yMMMd().format(controller.projectList[index].datecreated)} ${DateFormat.jm().format(controller.projectList[index].datecreated)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: AppFontSizes.small,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              controller.projectList[index].clientRating == null
                                  ? const SizedBox()
                                  : Row(
                                      children: [
                                        Text(
                                          controller
                                              .projectList[index].clientRating!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: AppFontSizes.regular),
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 15.sp,
                                        )
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        const Divider(),
                        SizedBox(
                          height: 1.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Row(
                            children: [
                              Text(
                                "Title: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppFontSizes.regular),
                              ),
                              Text(
                                controller.projectList[index].projectTitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppFontSizes.regular),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Row(
                            children: [
                              Text(
                                "Date & Time: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: AppFontSizes.regular),
                              ),
                              Text(
                                "${DateFormat.yMMMMd().format(controller.projectList[index].date)} ${DateFormat.jm().format(controller.projectList[index].time)}",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: AppFontSizes.regular),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Row(
                            children: [
                              Text(
                                "Status: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: AppFontSizes.regular),
                              ),
                              Text(
                                controller.projectList[index].status,
                                style: TextStyle(
                                    color:
                                        controller.projectList[index].status ==
                                                "Pending"
                                            ? AppColors.orange
                                            : controller.projectList[index]
                                                        .status ==
                                                    "Ongoing"
                                                ? Colors.black
                                                : controller.projectList[index]
                                                            .status ==
                                                        "Rejected"
                                                    ? Colors.red
                                                    : Colors.green,
                                    fontWeight: FontWeight.normal,
                                    fontSize: AppFontSizes.regular),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Text(
                            controller.projectList[index].message,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: AppFontSizes.regular),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        const Divider(),
                        SizedBox(
                          height: 2.h,
                        ),
                        index == (controller.projectList.length - 1)
                            ? const SizedBox(
                                height: 1,
                              )
                            : Container(
                                height: 1.h,
                                color: AppColors.light,
                              ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
