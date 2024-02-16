import 'dart:convert';

import 'package:get/get.dart';

List<Notif> notifFromJson(String str) =>
    List<Notif>.from(json.decode(str).map((x) => Notif.fromJson(x)));

String notifToJson(List<Notif> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notif {
  DateTime datecreated;
  String message;
  RxBool isSeen;
  String userid;
  String id;
  String title;

  Notif({
    required this.datecreated,
    required this.message,
    required this.isSeen,
    required this.userid,
    required this.id,
    required this.title,
  });

  factory Notif.fromJson(Map<String, dynamic> json) => Notif(
        datecreated: DateTime.parse(json["datecreated"]),
        message: json["message"],
        title: json["title"],
        isSeen: json["isSeen"] == true ? true.obs : false.obs,
        userid: json["userid"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "datecreated": datecreated.toIso8601String(),
        "message": message,
        "title": title,
        "isSeen": isSeen,
        "userid": userid,
        "id": id,
      };
}
