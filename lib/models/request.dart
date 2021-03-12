import 'package:realestate/models/property.dart';

class Request {
  final Property property;
  final String uid;
  final String userName;
  final String userId;
  final String userNumber;
  final String userPic;
  final String status;
  final String date;

  Request({
    this.property,
    this.date,
    this.uid,
    this.status,
    this.userName,
    this.userId,
    this.userNumber,
    this.userPic,
  });
}
