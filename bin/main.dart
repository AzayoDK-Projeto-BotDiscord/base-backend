import 'package:base_backend/infra/custom_server.dart';
import 'package:shelf/shelf.dart';

void main() async {
  var handler = const Pipeline().addHandler((Request req) {
    return Response.ok('Servidor online');
  });

  await CustomServer().initialize(
    handler: handler,
    address: 'localhost',
    port: 8080,
  );
}
