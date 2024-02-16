import 'dart:convert';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mediatooker/src/users_notification_screen/controller/users_notification_controller.dart';

class NotificationServices extends GetxService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token;

  @override
  Future<void> onInit() async {
    await checkNotificationPermission();
    super.onInit();
  }

  sendNotification(
      {required String userToken,
      required String message,
      required String title}) async {
    var body = jsonEncode({
      "to": userToken,
      "notification": {
        "body": message,
        "title": title,
        "subtitle": "",
      }
    });
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          "Authorization":
              "key=AAAAQB5bA-4:APA91bEPn_EAjqr1kCuorEIIbbsuTpMJb1RV9sjZg5J_4uft4F7MViTrGiIqWNENpB3mYtzTtWznqOwOrVzYpgUCY4rhxA6lQgWT6BRbhMtAErOuTQZ6-_C6vHZRYPe5Bg5csdcrAEtM",
          "Content-Type": "application/json"
        },
        body: body);
  }

  Future<void> notificationSetup() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: 'basic_channel_muted',
          channelName: 'Basic muted notifications ',
          channelDescription: 'Notification channel for muted basic tests',
          importance: NotificationImportance.High,
          playSound: false,
        )
      ],
    );
  }

  Future<void> onForegroundMessage() async {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        if (message.notification != null) {
          // if (Get.find<StorageService>().storage.read("notificationSound") ==
          //     true) {
          //   AwesomeNotifications().createNotification(
          //     content: NotificationContent(
          //       id: Random().nextInt(9999),
          //       channelKey: 'basic_channel',
          //       title: '${message.notification!.title}',
          //       body: '${message.notification!.body}',
          //       notificationLayout: NotificationLayout.BigText,
          //     ),
          //   );
          // } else {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: Random().nextInt(9999),
              channelKey: 'basic_channel_muted',
              title: '${message.notification!.title}',
              body: '${message.notification!.body}',
              notificationLayout: NotificationLayout.BigText,
            ),
          );
          Get.find<UsersNotificationController>().getNotifications();
          // }

          // call_unseen_messages();
        }
      },
    );
  }

  Future<void> checkNotificationPermission() async {
    var res = await messaging.requestPermission();
    if (res.authorizationStatus == AuthorizationStatus.authorized) {
      await notificationSetup();
      await onBackgroundMessage();
      await onForegroundMessage();
    }
  }
}

Future<void> onBackgroundMessage() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    // if (Get.find<StorageService>().storage.read("notificationSound") ==
    //     true) {
    //   AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //       id: Random().nextInt(9999),
    //       channelKey: 'basic_channel',
    //       title: '${message.notification!.title}',
    //       body: '${message.notification!.body}',
    //       notificationLayout: NotificationLayout.BigText,
    //     ),
    //   );
    // } else {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(9999),
        channelKey: 'basic_channel_muted',
        title: '${message.notification!.title}',
        body: '${message.notification!.body}',
        notificationLayout: NotificationLayout.BigText,
      ),
    );
    // if (Get.isRegistered<HomeScreenController>() == true &&
    //     message.data['notif_from'] == "Order Status") {
    //   Get.find<HomeScreenController>().getOrders();
    //   if (Get.isRegistered<OrderDetailScreenController>() == true) {
    //     Get.find<OrderDetailScreenController>().getOrderStatus();
    //   }
    // }
    // if (Get.isRegistered<HomeScreenController>() == true &&
    //     message.data['notif_from'] == "Chat") {
    //   Get.find<HomeScreenController>()
    //       .putMessageIdentifier(order_id: message.data['value']);
    //   if (Get.isRegistered<OrderDetailScreenController>()) {
    //     Get.find<OrderDetailScreenController>().hasMessage.value = true;
    //   }
    // }
    // }

    // call_unseen_messages();
  }
}
