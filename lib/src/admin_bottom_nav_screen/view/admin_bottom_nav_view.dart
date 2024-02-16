import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/src/admin_approval_screen/controller/admin_approval_controller.dart';
import 'package:mediatooker/src/admin_bottom_nav_screen/controller/admin_bottom_nav_controller.dart';
import 'package:mediatooker/src/admin_users_list_screen/controller/admin_users_list_controller.dart';
import 'package:sizer/sizer.dart';

import '../../../config/app_colors.dart';

class AdminBottomNavView extends StatefulWidget {
  const AdminBottomNavView({super.key});

  @override
  State<AdminBottomNavView> createState() => _AdminBottomNavViewState();
}

class _AdminBottomNavViewState extends State<AdminBottomNavView> {
  var controller = Get.put(AdminBottomNavController());
  @override
  void initState() {
    Get.put(AdminApprovalController());
    Get.put(AdminUsersListController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Obx(() => controller.screens[controller.currentSelectedIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBar(
            backgroundColor: Colors.white,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            // showSelectedLabels: true,
            // showUnselectedLabels: false,
            onDestinationSelected: (index) {
              controller.currentSelectedIndex.value = index;
            },
            elevation: 20,
            selectedIndex: controller.currentSelectedIndex.value,
            indicatorColor: Colors.white,
            destinations: <Widget>[
              NavigationDestination(
                  selectedIcon: Icon(
                    Icons.person,
                    size: 20.sp,
                    color: AppColors.orange,
                  ),
                  icon: Icon(
                    Icons.person,
                    size: 20.sp,
                  ),
                  label: "Approval"),
              NavigationDestination(
                  selectedIcon: Icon(
                    Icons.group,
                    size: 20.sp,
                    color: AppColors.orange,
                  ),
                  icon: Icon(
                    Icons.group,
                    size: 20.sp,
                  ),
                  label: "Users"),
            ]),
      ),
    );
  }
}
