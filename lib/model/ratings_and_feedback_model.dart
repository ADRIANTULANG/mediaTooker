import 'dart:convert';

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

  RatingsAndFeedback({
    required this.feedback,
    required this.userimage,
    required this.rating,
    required this.datecreated,
    required this.userid,
    required this.username,
    required this.id,
  });

  factory RatingsAndFeedback.fromJson(Map<String, dynamic> json) =>
      RatingsAndFeedback(
        feedback: json["feedback"],
        userimage: json["userimage"],
        rating: json["rating"].toString(),
        datecreated: DateTime.parse(json["datecreated"]),
        userid: json["userid"],
        username: json["username"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "feedback": feedback,
        "userimage": userimage,
        "rating": rating,
        "datecreated": datecreated.toIso8601String(),
        "userid": userid,
        "username": username,
        "id": id,
      };
}
