import 'package:base_backend/dao/dao.dart';
import 'package:base_backend/infra/database/db_configuration.dart';
import 'package:base_backend/models/music_history_model.dart';

class MusicHistoryDao implements DAO<MusicHistoryModel> {
  final DBConfiguration _dbConfiguration;
  MusicHistoryDao(this._dbConfiguration);

  @override
  Future<bool> create(MusicHistoryModel value) async {
    var result = await _dbConfiguration.execQuery(
      'INSERT INTO tb_music_history (name, idUserDiscord, idDiscordServer, url) value (?, ?, ?, ?)',
      [value.name, value.idUserDiscord, value.idDiscordServer, value.url],
    );
    return result.affectedRows > 0;
  }

  @override
  Future<bool> delete(int id) {
    var result = _dbConfiguration.execQuery(
      'DELETE FROM tb_music_history WHERE id = ?',
      [id],
    );
    return result.affectedRows > 0;
  }

  @override
  Future<List<MusicHistoryModel>> findeAll() async {
    var result = await _dbConfiguration.execQuery(
      'SELECT * FROM tb_music_history',
    );
    return result
        .map((r) => MusicHistoryModel.fromMap(r.fields))
        .toList()
        .cast<MusicHistoryModel>();
  }

  @override
  Future<MusicHistoryModel> findeOne(int id) async {
    var result = await _dbConfiguration.execQuery(
      'SELECT * FROM tb_music_history WHERE id = ?',
      [id],
    );
    return result.isEmpty ?? MusicHistoryModel.fromMap(result.first.fields);
  }

  // esse aqui foi feito, mas não vai ser usado.
  @override
  Future<bool> update(MusicHistoryModel value) async {
    var result = await _dbConfiguration.execQuery(
      'UPDATE tb_music_history SET name = ? url = ? WHERE id = ?',
      [value.name, value.url, value.id],
    );
    return result.affectedRows > 0;
  }

  // metodo para buscar musicas com base no id do usuário
  Future<List<MusicHistoryModel>> findAllByUserDiscord(
    String idUserDiscord,
  ) async {
    var result = await _dbConfiguration.execQuery(
      'SELECT * FROM tb_music_history WHERE idUserDiscord = ?',
      [idUserDiscord],
    );
    return result
        .map((r) => MusicHistoryModel.fromMap(r.fields))
        .toList()
        .cast<MusicHistoryModel>();
  }

  // metodo para buscar musicas com base no id do servidor
  Future<List<MusicHistoryModel>> findAllByDiscordServer(
    String idDiscordServer,
  ) async {
    var result = await _dbConfiguration.execQuery(
      'SELECT * FROM tb_music_history WHERE idDiscordServer = ?',
      [idDiscordServer],
    );
    return result
        .map((r) => MusicHistoryModel.fromMap(r.fields))
        .toList()
        .cast<MusicHistoryModel>();
  }
}
