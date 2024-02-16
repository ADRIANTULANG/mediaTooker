import 'dart:convert';

List<Bookings> bookingsFromJson(String str) =>
    List<Bookings>.from(json.decode(str).map((x) => Bookings.fromJson(x)));

String bookingsToJson(List<Bookings> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bookings {
  DateTime date;
  String clientId;
  String providerId;
  bool accepted;
  DateTime datecreated;
  DateTime time;
  String message;
  String status;
  String projectTitle;
  String id;
  String providerName;
  String providerEmail;
  String providerProfilePic;
  String providerAddress;
  String providerContact;
  String providerFcmToken;
  String clientName;
  String clientEmail;
  String clientProfilePic;
  String clientAddress;
  String clientContact;
  String clientFcmToken;
  bool isSeenByClient;
  bool isSeenByProvider;

  Bookings({
    required this.date,
    required this.clientId,
    required this.providerId,
    required this.accepted,
    required this.datecreated,
    required this.time,
    required this.message,
    required this.status,
    required this.projectTitle,
    required this.id,
    required this.providerName,
    required this.providerEmail,
    required this.providerProfilePic,
    required this.providerAddress,
    required this.providerContact,
    required this.clientName,
    required this.clientEmail,
    required this.clientProfilePic,
    required this.clientAddress,
    required this.clientContact,
    required this.isSeenByClient,
    required this.isSeenByProvider,
    required this.clientFcmToken,
    required this.providerFcmToken,
  });

  factory Bookings.fromJson(Map<String, dynamic> json) => Bookings(
        date: DateTime.parse(json["date"]),
        clientId: json["clientID"],
        providerId: json["providerID"],
        clientFcmToken: json["clientFcmToken"],
        providerFcmToken: json["providerFcmToken"],
        accepted: json["accepted"],
        isSeenByClient: json["isSeenByClient"],
        isSeenByProvider: json["isSeenByProvider"],
        datecreated: DateTime.parse(json["datecreated"]),
        time: DateTime.parse(json["time"]),
        message: json["message"],
        status: json["status"],
        projectTitle: json["projectTitle"],
        id: json["id"],
        providerName: json["providerName"],
        providerEmail: json["providerEmail"],
        providerProfilePic: json["providerProfilePic"],
        providerAddress: json["providerAddress"],
        providerContact: json["providerContact"],
        clientName: json["clientName"],
        clientEmail: json["clientEmail"],
        clientProfilePic: json["clientProfilePic"],
        clientAddress: json["clientAddress"],
        clientContact: json["clientContact"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "clientID": clientId,
        "providerID": providerId,
        "accepted": accepted,
        "clientFcmToken": clientFcmToken,
        "providerFcmToken": providerFcmToken,
        "isSeenByClient": isSeenByClient,
        "isSeenByProvider": isSeenByProvider,
        "datecreated": datecreated.toIso8601String(),
        "time": time.toIso8601String(),
        "message": message,
        "status": status,
        "projectTitle": projectTitle,
        "id": id,
        "providerName": providerName,
        "providerEmail": providerEmail,
        "providerProfilePic": providerProfilePic,
        "providerAddress": providerAddress,
        "providerContact": providerContact,
        "clientName": clientName,
        "clientEmail": clientEmail,
        "clientProfilePic": clientProfilePic,
        "clientAddress": clientAddress,
        "clientContact": clientContact,
      };
}
