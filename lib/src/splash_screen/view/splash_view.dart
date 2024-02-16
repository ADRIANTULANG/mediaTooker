import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller/splash_controller.dart';

class SplashView extends GetView<SplashViewController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashViewController());
    return Scaffold(
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Center(
          child: Container(
            height: 30.h,
            width: 100.w,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'))),
          ),
        ),
      ),
    );
  }
}
