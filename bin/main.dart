import 'package:base_backend/infra/custom_server.dart';
import 'package:base_backend/utils/custom_env.dart';
import 'package:shelf/shelf.dart';

void main() async {
  var handler = const Pipeline().addHandler((Request req) {
    return Response.ok('Servidor online');
  });

  await CustomServer().initialize(
    handler: handler,
    address: await CustomEnv.get<String>(key: 'SERVER_ADDRESS'),
    port: await CustomEnv.get<int>(key: 'SERVER_PORT'),
  );
}
