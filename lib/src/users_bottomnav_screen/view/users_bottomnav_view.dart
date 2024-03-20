import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/services/loading_dialog.dart';
import 'package:mediatooker/src/login_users_and_admin_screen/view/login_users_and_admin_view.dart';
import 'package:mediatooker/src/users_search_screen/view/users_search_view.dart';
import 'package:sizer/sizer.dart';
import '../../users_bookings_request_screen/controller/users_booking_request_controller.dart';
import '../../users_home_screen/controller/users_home_controller.dart';
import '../../users_notification_screen/controller/users_notification_controller.dart';
import '../../users_project_list_screen/controller/users_project_list_controller.dart';
import '../controller/users_bottomnav_controller.dart';
import 'package:badges/badges.dart' as badge;

class UsersBottomNavView extends GetView<UsersBottomNavViewController> {
  const UsersBottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UsersBottomNavViewController());
    Get.put(UsersHomeViewController());
    Get.put(UsersProjectListController());
    Get.put(UsersNotificationController());
    Get.put(UsersBookingRequestController());
    return DefaultTabController(
      length: controller.screens.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            'MediaTooker',
            style: TextStyle(
                letterSpacing: 3,
                color: AppColors.orange,
                fontSize: AppFontSizes.extraLarge),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                Get.to(() => const UsersSearchPage());
              },
              child: Icon(
                Icons.search,
                color: AppColors.orange,
                size: 23.sp,
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            GestureDetector(
              onTap: () async {
                LoadingDialog.showLoadingDialog();
                Timer(const Duration(seconds: 3), () async {
                  Get.find<StorageServices>().removeStorageCredentials();
                  await GoogleSignIn().signOut();
                  await FirebaseAuth.instance.signOut();
                  Get.offAll(() => const LoginView());
                });
              },
              child: Icon(
                Icons.power_settings_new_rounded,
                color: AppColors.orange,
                size: 23.sp,
              ),
            ),
            SizedBox(
              width: 5.w,
            )
          ],
          bottom: TabBar(
            labelColor: AppColors.orange,
            indicatorColor: AppColors.light,
            unselectedLabelColor: AppColors.dark,
            tabs: [
              Tab(
                iconMargin: EdgeInsets.only(top: 1.h),
                icon: Icon(
                  Icons.home_rounded,
                  size: 23.sp,
                ),
                text: 'Home',
              ),
              Tab(
                  iconMargin: EdgeInsets.only(top: 1.h),
                  icon: Icon(
                    Icons.book,
                    size: 23.sp,
                  ),
                  text: 'Bookings'),
              Tab(
                  iconMargin: EdgeInsets.only(top: 1.h),
                  icon: Icon(
                    Icons.video_camera_back_rounded,
                    size: 23.sp,
                  ),
                  text: 'Projects'),
              Tab(
                  iconMargin: EdgeInsets.only(top: 1.h),
                  icon: Obx(
                    () => badge.Badge(
                      showBadge: Get.find<UsersNotificationController>()
                                  .unseenCount
                                  .value >
                              0
                          ? true
                          : false,
                      badgeStyle:
                          const badge.BadgeStyle(badgeColor: AppColors.orange),
                      badgeContent: Text(
                        Get.find<UsersNotificationController>()
                            .unseenCount
                            .value
                            .toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.light),
                      ),
                      child: Icon(
                        Icons.notifications,
                        size: 23.sp,
                      ),
                    ),
                  ),
                  text: 'Notifications'),
            ],
          ),
        ),
        body: TabBarView(
          children: controller.screens,
        ),
      ),
    );
  }
}
