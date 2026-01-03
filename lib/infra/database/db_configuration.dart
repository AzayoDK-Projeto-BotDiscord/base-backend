abstract class DBConfiguration {
  Future<dynamic> createConnection();
  Future<dynamic> get connection;

  // ignore: strict_top_level_inference
  execQuery(String sql, [List? params]);
}
