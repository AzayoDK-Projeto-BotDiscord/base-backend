import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  int? id;
  String? username;
  String? email;
  String? password;
  DateTime? dtCreated;
  DateTime? dtUpdated;
  int? idPermission;
  int? idStatus;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.dtCreated,
    this.dtUpdated,
    this.idPermission,
    this.idStatus,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      dtCreated: map['dtCreated'],
      dtUpdated: map['dtUpdated'],
      idPermission: map['idPermission'],
      idStatus: map['idStatus'],
    );
  }

  factory UserModel.fromEmail(Map map) {
    return UserModel()
      ..id = map['id']
      ..email = map['email']
      ..password = map['password']
      ..idPermission = map['idPermission']
      ..idStatus = map['idStatus'];
  }

  factory UserModel.fromRequest(Map map) {
    return UserModel()
      ..username = map['username']
      ..email = map['email']
      ..password = map['password'];
  }

  Map toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'dtCreated': dtCreated?.toIso8601String(),
      'dtUpdated': dtUpdated?.toIso8601String(),
      'idPermission': idPermission,
      'idStatus': idStatus,
    };
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
