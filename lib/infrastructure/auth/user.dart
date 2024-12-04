import 'package:f_bapp/infrastructure/auth/privileges.dart';

class User {
  final String personName;
  final String? personLastName;
  final String userName;
  final String userEmail;
  final dynamic userPhone;
  final String? lastSession;
  final bool usernameChangeNeeded;
  final bool isPasswordExpired;

  User({
    required this.personName,
    this.personLastName,
    required this.userName,
    required this.userEmail,
    this.userPhone,
    required this.lastSession,
    required this.usernameChangeNeeded,
    required this.isPasswordExpired,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        personName: json['personName'],
        personLastName: json['personLastName'],
        userName: json['userName'],
        userEmail: json['userEmail'],
        userPhone: json['userPhone'],
        lastSession: json['lastSession'],
        usernameChangeNeeded: json['usernameChangeNeeded'],
        isPasswordExpired: json['isPasswordExpired'],
      );

  Map<String, dynamic> toJson() {
    return {
      'personName': personName,
      'personLastName': personLastName,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'lastSession': lastSession,
      'usernameChangeNeeded': usernameChangeNeeded,
      'isPasswordExpired': isPasswordExpired,

    };
  }

  @override
  String toString() {
    return '''
    User(
      personName: $personName,
      personLastName: $personLastName,
      userName: $userName,
      userEmail: $userEmail,
      userPhone: $userPhone,
      lastSession: $lastSession,
      usernameChangeNeeded: $usernameChangeNeeded,
      isPasswordExpired: $isPasswordExpired,
    )
    ''';

  }
}