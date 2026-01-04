import 'dart:convert';

import 'package:base_backend/api/api.dart';
import 'package:base_backend/infra/security/security_service.dart';
import 'package:base_backend/service/login_service.dart';
import 'package:base_backend/to/auth_to.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class LoginApi extends Api {
  final SecurityService _securityService;
  final LoginService _loginService;
  LoginApi(this._securityService, this._loginService);

  @override
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    List<int>? requiredRole,
  }) {
    Router router = Router();

    router.post('/login', (Request req) async {
      var body = await req.readAsString();
      if (body.isEmpty) {
        return Response(400, body: '{"error": "Empty body"}');
      }

      var authTO = AuthTo.fromRequest(body);

      var user = await _loginService.authenticate(authTO);

      // Primeiro verifica se o usuário existe
      if (user == null) {
        return Response(401, body: '{"error": "Invalid credentials"}');
      }

      // Depois verifica o status da conta
      if (user.idStatus == 2) {
        return Response.forbidden(
          '{"error": "user_inactive", "message": "Your account is inactive. Please contact support."}',
        );
      }
      if (user.idStatus == 3) {
        return Response.forbidden(
          '{"error": "user_blocked", "message": "Your account has been blocked for security reasons."}',
        );
      }

      // Só gera o token se passou em todas as verificações
      var jwt = await _securityService.generateJWT(
        user.id.toString(),
        user.idPermission ?? 2,
        user.idStatus ?? 1,
      );
      return Response.ok(jsonEncode({'token': jwt}));
    });

    return createHandler(router: router.call, middlewares: middlewares);
  }
}
