import 'package:base_backend/dao/dao.dart';
import 'package:base_backend/infra/database/db_configuration.dart';
import 'package:base_backend/models/user_model.dart';

class UserDao implements DAO<UserModel> {
  final DBConfiguration _dbConfiguration;
  UserDao(this._dbConfiguration);

  @override
  Future<bool> create(UserModel value) async {
    var result = await _dbConfiguration.execQuery(
      'INSERT INTO tb_users (username, email, password, idPermission, idStatus) value (?, ?, ?, ?, ?);',
      [value.username, value.email, value.password, 2, 1],
    );
    return result.affectedRows > 0;
  }

  @override
  Future<bool> delete(int id) async {
    var result = _dbConfiguration.execQuery(
      'DELETE FROM tb_users WHERE id = ?',
      [id],
    );
    return result.affectedRows > 0;
  }

  @override
  Future<List<UserModel>> findeAll() async {
    var result = await _dbConfiguration.execQuery(
      'SELECT id, username, email, dtCreated, dtUpdated, idPermission, idStatus  FROM tb_users',
    );
    return result
        .map((r) => UserModel.fromMap(r.fields))
        .toList()
        .cast<UserModel>();
  }

  @override
  Future<UserModel> findeOne(int id) async {
    var result = await _dbConfiguration.execQuery(
      'SELECT id, username, email, dtCreated, dtUpdated, idPermission, idStatus FROM tb_users WHERE id = ?',
      [id],
    );
    return result.isEmpty ?? UserModel.fromMap(result.first.fields);
  }

  @override
  Future<bool> update(UserModel value) async {
    var result = await _dbConfiguration.execQuery(
      'UPDATE tb_users SET username = ? password = ? WHERE id = ?',
      [value.username, value.password, value.password, value.id],
    );
    return result.affectedRows > 0;
  }

  // Método específico para login - busca por email
  Future<UserModel?> findByEmail(String email) async {
    var result = await _dbConfiguration.execQuery(
      'SELECT id, email, password, idPermission, idStatus FROM tb_users WHERE email = ?',
      [email],
    );
    return result.affectedRows == 0
        ? null
        : UserModel.fromEmail(result.first.fields);
  }

  // Método para vincular o id do usuário do discord
  Future<bool> updateIdUserDiscord(UserModel value) async {
    var result = await _dbConfiguration.execQuery(
      'UPDATE tb_users SET idUserDiscord = ? WHERE id = ?',
      [value.idUserDiscord, value.id],
    );
    return result.affectedRows > 0;
  }
}
