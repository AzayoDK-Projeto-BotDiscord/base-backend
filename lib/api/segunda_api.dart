import 'package:base_backend/api/api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class SegundaApi extends Api {
  @override
  Handler getHandler({List<Middleware>? middlewares}) {
    Router router = Router();

    router.get('/segunda', (Request req) {
      return Response.ok('{"mensagem": "Segunda API funcionando"}');
    });

    return createHandler(router: router.call, middlewares: middlewares);
  }
}
