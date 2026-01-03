import 'package:base_backend/api/api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ExemploApi extends Api {
  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    // Get /exemplo
    router.get('/exemplo', (Request req) {
      return Response.ok('Rota de exemplo funcionando');
    });

    return createHandler(
      router: router.call,
      middlewares: middlewares,
      isSecurity: isSecurity,
    );
  }
}
