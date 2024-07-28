import 'dart:convert';

import 'package:get/get.dart';

List<RatingsAndFeedback> ratingsAndFeedbackFromJson(String str) =>
    List<RatingsAndFeedback>.from(
        json.decode(str).map((x) => RatingsAndFeedback.fromJson(x)));

String ratingsAndFeedbackToJson(List<RatingsAndFeedback> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RatingsAndFeedback {
  String feedback;
  String userimage;
  String rating;
  DateTime datecreated;
  String userid;
  String username;
  String id;
  String projectID;
  String projectName;

  List<Reply> replies;
  RxBool isReplying;

  RatingsAndFeedback({
    required this.feedback,
    required this.userimage,
    required this.rating,
    required this.datecreated,
    required this.userid,
    required this.username,
    required this.id,
    required this.replies,
    required this.isReplying,
    required this.projectName,
    required this.projectID,
  });

  factory RatingsAndFeedback.fromJson(Map<String, dynamic> json) =>
      RatingsAndFeedback(
        feedback: json["feedback"],
        userimage: json["userimage"],
        rating: json["rating"].toString(),
        datecreated: DateTime.parse(json["datecreated"]),
        userid: json["userid"],
        username: json["username"],
        projectID: json["projectID"],
        projectName: json["projectName"],
        id: json["id"],
        isReplying: false.obs,
        replies:
            List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "feedback": feedback,
        "userimage": userimage,
        "rating": rating,
        "datecreated": datecreated.toIso8601String(),
        "userid": userid,
        "username": username,
        "projectID": projectID,
        "projectName": projectName,
        "id": id,
        "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
      };
}

class Reply {
  String image;
  String replymessage;
  String name;
  DateTime datecreated;
  String userid;

  Reply({
    required this.image,
    required this.replymessage,
    required this.name,
    required this.datecreated,
    required this.userid,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        image: json["image"],
        replymessage: json["replymessage"],
        name: json["name"],
        datecreated: DateTime.parse(json["datecreated"].toString()),
        userid: json["userid"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "replymessage": replymessage,
        "name": name,
        "datecreated": datecreated.toIso8601String(),
        "userid": userid,
      };
}
