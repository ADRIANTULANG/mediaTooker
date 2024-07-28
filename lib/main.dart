import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/services/notification_services.dart';
import 'package:mediatooker/src/users_chat_screen/controller/users_chat_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'src/splash_screen/view/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await [
    Permission.storage,
    Permission.manageExternalStorage,
    Permission.accessMediaLocation
  ].request();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAkgdXfBxQkRcrWqYW4dIaYAs5fzhVe-O4',
          appId: '1:275387188206:android:dba53b99fec3f45b5504ff',
          messagingSenderId: '275387188206',
          storageBucket: "media-tooker-7ec79.appspot.com",
          projectId: 'media-tooker-7ec79'));
  await Get.putAsync<NotificationServices>(() async => NotificationServices());
  await Get.putAsync<StorageServices>(() async => StorageServices());
  Stripe.publishableKey =
      'pk_test_51PRVcfRpZUkGY2RJvDT0DcpspQKHDjlKtE4WBUlRPVJVE9jjAJrRBIqfIw20sFK61cecI2U34BGTTQwSqv658eLk00q6qW8TSy';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      log("detached");
    } else if (state == AppLifecycleState.paused) {
      log("paused");
    } else if (state == AppLifecycleState.resumed) {
      log("resumed");
      if (Get.find<StorageServices>().storage.read('id') != null) {
        try {
          if (Get.isRegistered<UsersChatController>()) {
            Get.find<UsersChatController>()
                .updateCurrentUserStatusOnline(status: true);
          }
        } on Exception catch (_) {}
      }
    } else if (state == AppLifecycleState.inactive) {
      log("inactive");
      if (Get.find<StorageServices>().storage.read('id') != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(Get.find<StorageServices>().storage.read("id"))
              .update({"isOnline": false});
        } on Exception catch (_) {}
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MediaTooker',
        theme: ThemeData(
          fontFamily: "BariolNormal",
          primarySwatch: MaterialColor(0xffff6600, AppColors.mainMaterialColor),
        ),
        home: const SplashView(),
      );
    });
  }
}
