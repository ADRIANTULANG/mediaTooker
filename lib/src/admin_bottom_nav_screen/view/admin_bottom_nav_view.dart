import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/src/admin_approval_screen/controller/admin_approval_controller.dart';
import 'package:mediatooker/src/admin_bottom_nav_screen/controller/admin_bottom_nav_controller.dart';
import 'package:mediatooker/src/admin_categories_screen/controller/admin_categories_controller.dart';
import 'package:mediatooker/src/admin_income_screen/controller/admin_income_controller.dart';
import 'package:mediatooker/src/admin_reports_screen/controller/admin_reports_controller.dart';
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
    Get.put(AdminReportsController());
    Get.put(AdminIncomeController());
    Get.put(AdminCategoriesController());

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
              if (index == 0) {
                Get.find<AdminApprovalController>().getPendingUsers();
              }
              if (index == 1) {
                Get.find<AdminReportsController>().getReportedUsers();
              }
              if (index == 2) {
                Get.find<AdminUsersListController>().getUsers();
              }
              if (index == 3) {
                Get.find<AdminIncomeController>().getPayments();
              }
              if (index == 4) {
                Get.find<AdminCategoriesController>().getCategories();
              }
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
                    Icons.report,
                    size: 20.sp,
                    color: AppColors.orange,
                  ),
                  icon: Icon(
                    Icons.report,
                    size: 20.sp,
                  ),
                  label: "Reports"),
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
              NavigationDestination(
                  selectedIcon: Icon(
                    Icons.bar_chart,
                    size: 20.sp,
                    color: AppColors.orange,
                  ),
                  icon: Icon(
                    Icons.bar_chart,
                    size: 20.sp,
                  ),
                  label: "Income"),
              NavigationDestination(
                  selectedIcon: Icon(
                    Icons.category,
                    size: 20.sp,
                    color: AppColors.orange,
                  ),
                  icon: Icon(
                    Icons.category,
                    size: 20.sp,
                  ),
                  label: "Categories"),
            ]),
      ),
    );
  }
}
