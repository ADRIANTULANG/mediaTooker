import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:sizer/sizer.dart';

import '../controller/users_notification_controller.dart';

class UsersNotificationView extends GetView<UsersNotificationController> {
  const UsersNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: 100.h,
      width: 100.w,
      child: Obx(
        () => controller.notificationList.isEmpty
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
                                image: AssetImage('assets/images/logo.png'))),
                      ),
                      Text(
                        "No available notifications.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.regular),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                itemCount: controller.notificationList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      controller.updateIsSeen(
                          docid: controller.notificationList[index].id);
                      controller.notificationList[index].isSeen.value = true;
                      controller.countUnseen();
                    },
                    child: Obx(
                      () => Container(
                        decoration: BoxDecoration(
                            color:
                                controller.notificationList[index].isSeen.value
                                    ? null
                                    : AppColors.light,
                            border: const Border(
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
                                controller.notificationList[index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppFontSizes.medium),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w, right: 5.w),
                              child: Text(
                                "${DateFormat.yMMMMd().format(controller.notificationList[index].datecreated)} ${DateFormat.jm().format(controller.notificationList[index].datecreated)}",
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
                              child: Text(
                                controller.notificationList[index].message,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: AppFontSizes.regular),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    ));
  }
}
