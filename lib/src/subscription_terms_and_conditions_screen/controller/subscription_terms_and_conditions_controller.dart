import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mediatooker/services/getstorage_services.dart';

import '../../users_bookings_request_screen/controller/users_booking_request_controller.dart';

class SubscriptionTermsAndConditionsController extends GetxController {
  RxString selectedSubscriptionType = ''.obs;
  RxInt bookings = 0.obs;
  RxInt uploads = 0.obs;
  RxString amount = "0.0".obs;

  Map<String, dynamic>? paymentIntentData;
  RxString clientSecret = ''.obs;

  // RxString currency = "PHP".obs;
  // RxString artistID = "".obs;
  // RxString artID = "".obs;
  RxBool isStripeSelected = false.obs;
  RxBool isLoadingPayment = false.obs;

  RxString currentSubscription = ''.obs;
  RxInt currentUpload = 0.obs;
  RxInt currentBooking = 0.obs;

  getSubscriptions() async {
    try {
      var user = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'))
          .get();
      if (user.exists) {
        currentSubscription.value =
            user['subscription'].toString().capitalizeFirst.toString();
        currentUpload.value = user['uploads'];
        currentBooking.value = user['bookings'];
      }
    } catch (_) {
      log("ERROR (getSubscriptions): Something went wrong ${_.toString()}");
    }
  }

  Future<void> makePayment(
      {required String amount, required String currency}) async {
    try {
      // final paymentMethod =
      //           await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(
      //             paymentMethodData: PaymentMethodData (billingDetails: BillingD)
      //           ));
      paymentIntentData = await createPaymentIntent(amount, currency);
      clientSecret.value = paymentIntentData!['client_secret'].toString();
      log("CLIENT SECRET ${clientSecret.value}");
      if (paymentIntentData != null) {
        log(amount);
        log(currency);
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          // applePay: PaymentSheetApplePay(merchantCountryCode: currency),
          googlePay: const PaymentSheetGooglePay(merchantCountryCode: "PHP"),

          merchantDisplayName: 'Prospects',
          customerId: Get.find<StorageServices>().storage.read('id'),
          // sk_test_51Lize7DbhTM8s4NtDpmRR7iPcppW41EG2AYCHLmJjopgdCnUUP85FQVvmEt98rCnpnr59xQd6zOP7D4kfkMDXqKM00ejfzOuph
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
        ));
        log("here");

        displayPaymentSheet();
      }
    } catch (e, s) {
      log('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // final paymentIntent =
      //     await Stripe.instance.retrievePaymentIntent(clientSecret.value);
      // final paymentId =  paymentIntent.id;
      // log("PAYMENT_ID::: $paymentId");
      await FirebaseFirestore.instance.collection("payments").add({
        "payment_id": clientSecret.value,
        "user": Get.find<StorageServices>().storage.read('id'),
        "amount": amount.value,
        "subscription_type": selectedSubscriptionType.value,
        "uploads": uploads.value,
        "bookings": bookings.value,
        "datecreated": DateTime.now()
      });
      int newUploadCount = currentUpload.value + uploads.value;
      int newBookingsCount = currentBooking.value + bookings.value;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(Get.find<StorageServices>().storage.read('id'))
          .update({
        "subscription": selectedSubscriptionType.value,
        "uploads": newUploadCount,
        "bookings": newBookingsCount
      });
      Get.back();
      Get.back();
      Get.snackbar('Payment', 'Payment Successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 4));
      Get.find<UsersBookingRequestController>().getSubscriptions();
      isLoadingPayment(false);
    } on Exception catch (e) {
      if (e is StripeException) {
        log("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        log("Unforeseen error: $e");
      }
    } catch (e) {
      log("exception:$e");
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    var amountString = double.parse(amount).toInt();
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amountString.toString()),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51PRVcfRpZUkGY2RJWXdhbm0PHkQ0pNB1QHTrisLaAa18OvpWzSVf6zFnKUsPkk0QgMYLGFwvUhUYWBKTsnbiwgWG00b6uzPs5B',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      // log(jsonDecode(response.body)['clientSecret']);
      return jsonDecode(response.body);
    } catch (err) {
      log('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  @override
  void onInit() async {
    selectedSubscriptionType.value = await Get.arguments['type'];
    bookings.value = await Get.arguments['bookings'];
    uploads.value = await Get.arguments['uploads'];
    amount.value = await Get.arguments['amount'];
    getSubscriptions();
    super.onInit();
  }
}
