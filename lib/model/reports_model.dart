// To parse this JSON data, do
//
//     final reports = reportsFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<Reports> reportsFromJson(String str) =>
    List<Reports>.from(json.decode(str).map((x) => Reports.fromJson(x)));

String reportsToJson(List<Reports> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reports {
  String image;
  String reporterImage;
  String name;
  String description;
  String reporterId;
  DateTime datecreated;
  String userid;
  String reporterName;
  String email;
  String id;
  RxBool restricted;
  List<String> categories;

  Reports({
    required this.image,
    required this.reporterImage,
    required this.name,
    required this.description,
    required this.reporterId,
    required this.datecreated,
    required this.userid,
    required this.reporterName,
    required this.email,
    required this.id,
    required this.restricted,
    required this.categories,
  });

  factory Reports.fromJson(Map<String, dynamic> json) => Reports(
        image: json["image"],
        reporterImage: json["reporterImage"],
        name: json["name"],
        description: json["description"],
        reporterId: json["reporterID"],
        datecreated: DateTime.parse(json["datecreated"]),
        userid: json["userid"],
        reporterName: json["reporterName"],
        email: json["email"],
        id: json["id"],
        restricted: json["restricted"] == true ? true.obs : false.obs,
        categories: List<String>.from(json["categories"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "reporterImage": reporterImage,
        "name": name,
        "description": description,
        "reporterID": reporterId,
        "datecreated": datecreated.toIso8601String(),
        "userid": userid,
        "reporterName": reporterName,
        "email": email,
        "id": id,
        "restricted": restricted,
        "categories": List<dynamic>.from(categories.map((x) => x)),
      };
}
