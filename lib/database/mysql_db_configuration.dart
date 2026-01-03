import 'package:base_backend/database/db_configuration.dart';
import 'package:base_backend/utils/custom_env.dart';
import 'package:mysql1/mysql1.dart';

class MysqlDbConfiguration implements DBConfiguration {
  MySqlConnection? _connection;

  @override
  Future<MySqlConnection> get connection async {
    _connection ??= await createConnection();
    if (_connection == null) {
      throw Exception('[ERROR/DB] -> Failed Create Connection');
    }
    return _connection!;
  }

  @override
  Future<MySqlConnection> createConnection() async {
    return await MySqlConnection.connect(
      ConnectionSettings(
        host: await CustomEnv.get<String>(key: 'DB_HOST'),
        port: await CustomEnv.get<int>(key: 'DB_PORT'),
        user: await CustomEnv.get<String>(key: 'DB_USER'),
        password: await CustomEnv.get<String>(key: 'DB_PASSWORD'),
        db: await CustomEnv.get<String>(key: 'DB_SCHEMA'),
      ),
    );
  }

  @override
  execQuery(String sql, [List<dynamic>? params]) async {
    var conn = await connection;
    return await conn.query(sql, params);
  }
}
