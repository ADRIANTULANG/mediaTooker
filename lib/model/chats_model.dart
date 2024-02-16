import 'dart:convert';

List<Chats> chatsFromJson(String str) =>
    List<Chats>.from(json.decode(str).map((x) => Chats.fromJson(x)));

String chatsToJson(List<Chats> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chats {
  String sender;
  String chats;
  DateTime datecreated;
  String type;
  String url;

  Chats({
    required this.sender,
    required this.chats,
    required this.datecreated,
    required this.type,
    required this.url,
  });

  factory Chats.fromJson(Map<String, dynamic> json) => Chats(
        sender: json["sender"],
        chats: json["chats"],
        datecreated: DateTime.parse(json["datecreated"]),
        type: json["type"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "sender": sender,
        "chats": chats,
        "datecreated": datecreated.toIso8601String(),
        "type": type,
        "url": url,
      };
}
