// To parse this JSON data, do
//
//     final payments = paymentsFromJson(jsonString);

import 'dart:convert';

List<Payments> paymentsFromJson(String str) =>
    List<Payments>.from(json.decode(str).map((x) => Payments.fromJson(x)));

String paymentsToJson(List<Payments> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Payments {
  String amount;
  String paymentId;
  DateTime datecreated;
  String subscriptionType;
  int bookings;
  String user;
  int uploads;
  String id;
  String image;
  String name;
  String email;
  String contactno;

  Payments({
    required this.amount,
    required this.paymentId,
    required this.datecreated,
    required this.subscriptionType,
    required this.bookings,
    required this.user,
    required this.uploads,
    required this.id,
    required this.image,
    required this.name,
    required this.email,
    required this.contactno,
  });

  factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        amount: json["amount"],
        paymentId: json["payment_id"],
        datecreated: DateTime.parse(json["datecreated"]),
        subscriptionType: json["subscription_type"],
        bookings: json["bookings"],
        user: json["user"],
        uploads: json["uploads"],
        id: json["id"],
        image: json["image"],
        name: json["name"],
        email: json["email"],
        contactno: json["contactno"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "payment_id": paymentId,
        "datecreated": datecreated.toIso8601String(),
        "subscription_type": subscriptionType,
        "bookings": bookings,
        "user": user,
        "uploads": uploads,
        "id": id,
        "image": image,
        "name": name,
        "email": email,
        "contactno": contactno,
      };
}
