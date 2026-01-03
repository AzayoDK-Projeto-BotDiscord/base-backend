import 'package:base_backend/api/api.dart';
import 'package:base_backend/security/security_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class LoginApi extends Api {
  final SecurityService _securityService;

  LoginApi(this._securityService);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    // POST /login - Retorna um token JWT
    router.post('/login', (Request req) async {
      // Por enquanto, simula um login bem-sucedido
      // Em um caso real, você validaria email/senha aqui
      var token = await _securityService.generateJWT('1');
      return Response.ok('{"token": "$token"}');
    });

    return createHandler(
      router: router.call,
      middlewares: middlewares,
      isSecurity: false,
    );
  }
}
