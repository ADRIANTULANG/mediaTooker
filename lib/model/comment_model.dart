import 'dart:convert';

List<Comments> commentsFromJson(String str) =>
    List<Comments>.from(json.decode(str).map((x) => Comments.fromJson(x)));

String commentsToJson(List<Comments> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comments {
  String comment;
  String postid;
  DateTime datecreated;
  String userid;
  String id;
  String userprofile;
  String username;

  Comments({
    required this.comment,
    required this.postid,
    required this.datecreated,
    required this.userid,
    required this.id,
    required this.userprofile,
    required this.username,
  });

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        comment: json["comment"],
        postid: json["postid"],
        datecreated: DateTime.parse(json["datecreated"]),
        userid: json["userid"],
        id: json["id"],
        userprofile: json["userprofile"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "postid": postid,
        "datecreated": datecreated.toIso8601String(),
        "userid": userid,
        "id": id,
        "userprofile": userprofile,
        "username": username,
      };
}
