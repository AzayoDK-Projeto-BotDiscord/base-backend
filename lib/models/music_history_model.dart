import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MusicHistoryModel {
  int? id;
  String? name;
  String? idUserDiscord;
  String? idDiscordServer;
  String? url;
  DateTime? dtCreated;

  MusicHistoryModel({
    this.id,
    this.name,
    this.idUserDiscord,
    this.idDiscordServer,
    this.url,
    this.dtCreated,
  });

  factory MusicHistoryModel.fromMap(Map<String, dynamic> map) {
    return MusicHistoryModel(
      id: map['id'],
      name: map['name'],
      idUserDiscord: map['idUserDiscord'],
      idDiscordServer: map['idDiscordServer'],
      url: map['url'],
      dtCreated: map['dtCreated'],
    );
  }

  factory MusicHistoryModel.fromRequest(Map map) {
    return MusicHistoryModel()
      ..name = map['name']
      ..idUserDiscord = map['idUserDiscord']
      ..idDiscordServer = map['idDiscordServer']
      ..url = map['url'];
  }

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'idUserDiscord': idUserDiscord,
      'idDiscordServer': idDiscordServer,
      'url': url,
      'dtCreated': dtCreated?.toIso8601String(),
    };
  }

  factory MusicHistoryModel.fromJson(String source) =>
      MusicHistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
