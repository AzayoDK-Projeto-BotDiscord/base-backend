import 'package:base_backend/api/login_api.dart';
import 'package:base_backend/api/music_history_api.dart';
import 'package:base_backend/api/register_api.dart';
import 'package:base_backend/api/user_api.dart';
import 'package:base_backend/infra/custom_server.dart';
import 'package:base_backend/infra/depedency_injector/injects.dart';
import 'package:base_backend/infra/middleware_interception.dart';
import 'package:base_backend/utils/custom_env.dart';
import 'package:shelf/shelf.dart';

void main() async {
  // Iniciazar o Injetor de Dependencias
  final di = Injects.initialize();

  // Cascade de APIs
  // roles admin = 1 user = 2 bot =3
  var cascade = Cascade()
      .add(di<LoginApi>().getHandler())
      .add(di<RegisterApi>().getHandler())
      .add(
        di<MusicHistoryApi>().getHandler(
          isSecurity: true,
          requiredRole: [1, 3],
        ),
      )
      .add(di<UserApi>().getHandler(isSecurity: true, requiredRole: [1, 3]))
      .handler;

  // Pipeline de middlewares
  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(MiddlewareInterception.contentTypeJson)
      .addMiddleware(MiddlewareInterception.cors) // Descomente se precisar
      .addHandler(cascade);

  // iniciando o servidor
  await CustomServer().initialize(
    handler: handler,
    address: await CustomEnv.get<String>(key: 'SERVER_ADDRESS'),
    port: await CustomEnv.get<int>(key: 'SERVER_PORT'),
  );
}
