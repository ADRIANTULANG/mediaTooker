// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String address;
  bool isApprovedByAdmin;
  String coverPhoto;
  String usertype;
  bool isOnline;
  DateTime datecreated;
  String userid;
  String profilePhoto;
  String provider;
  String name;
  String documentLink;
  String fcmToken;
  String email;
  String status;
  String contactno;
  String id;
  String accountType;
  bool restricted;
  RxBool isDownloading;
  RxDouble progress;

  User({
    required this.address,
    required this.isApprovedByAdmin,
    required this.coverPhoto,
    required this.usertype,
    required this.isOnline,
    required this.datecreated,
    required this.userid,
    required this.profilePhoto,
    required this.provider,
    required this.name,
    required this.documentLink,
    required this.fcmToken,
    required this.email,
    required this.status,
    required this.contactno,
    required this.id,
    required this.isDownloading,
    required this.progress,
    required this.accountType,
    required this.restricted,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        address: json["address"],
        isApprovedByAdmin: json["isApprovedByAdmin"],
        coverPhoto: json["coverPhoto"],
        usertype: json["usertype"],
        isOnline: json["isOnline"],
        isDownloading: false.obs,
        progress: 0.0.obs,
        datecreated: DateTime.parse(json["datecreated"]),
        userid: json["userid"],
        profilePhoto: json["profilePhoto"],
        provider: json["provider"],
        name: json["name"],
        documentLink: json["documentLink"],
        fcmToken: json["fcmToken"],
        email: json["email"],
        status: json["status"],
        contactno: json["contactno"],
        restricted: json["restricted"],
        id: json["id"],
        accountType: json["accountType"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "isApprovedByAdmin": isApprovedByAdmin,
        "coverPhoto": coverPhoto,
        "usertype": usertype,
        "isDownloading": isDownloading,
        "progress": progress,
        "accountType": accountType,
        "isOnline": isOnline,
        "datecreated": datecreated.toIso8601String(),
        "userid": userid,
        "profilePhoto": profilePhoto,
        "provider": provider,
        "name": name,
        "documentLink": documentLink,
        "restricted": restricted,
        "fcmToken": fcmToken,
        "email": email,
        "status": status,
        "contactno": contactno,
        "id": id,
      };
}
