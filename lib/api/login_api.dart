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
    int? requiredRole,
  }) {
    Router router = Router();

    router.post('/login', (Request req) async {
      var body = await req.readAsString();
      if (body.isEmpty) {
        return Response(400, body: '{"error": "Empty body"}');
      }

      var authTO = AuthTo.fromRequest(body);

      var user = await _loginService.authenticate(authTO);
      if (user != null) {
        var jwt = await _securityService.generateJWT(
          user.id.toString(),
          user.idPermission ?? 2, // Default para user se não tiver
        );
        return Response.ok(jsonEncode({'token': jwt}));
      } else {
        return Response(401, body: '{"error": "Invalid credentials"}');
      }
    });

    return createHandler(router: router.call, middlewares: middlewares);
  }
}
