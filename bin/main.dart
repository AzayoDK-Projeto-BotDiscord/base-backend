import 'package:base_backend/api/exemplo_api.dart';
import 'package:base_backend/api/segunda_api.dart';
import 'package:base_backend/infra/custom_server.dart';
import 'package:base_backend/infra/middleware_interception.dart';
import 'package:base_backend/utils/custom_env.dart';
import 'package:shelf/shelf.dart';

void main() async {
  var exemploApi = ExemploApi();
  var segundaApi = SegundaApi();

  // Cascade: tenta cada API em sequência
  var cascade = Cascade()
      .add(exemploApi.getHandler())
      .add(segundaApi.getHandler())
      .handler;

  // usa o handler da api
  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(MiddlewareInterception.contentTypeJson)
      // .addMiddleware(MiddlewareInterception.cors) // Descomente se precisar
      .addHandler(cascade);

  // iniciando o servidor
  await CustomServer().initialize(
    handler: handler,
    address: await CustomEnv.get<String>(key: 'SERVER_ADDRESS'),
    port: await CustomEnv.get<int>(key: 'SERVER_PORT'),
  );
}
