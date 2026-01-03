import 'dart:convert';

import 'package:base_backend/api/api.dart';
import 'package:base_backend/security/security_service.dart';
import 'package:base_backend/service/login_service.dart';
import 'package:base_backend/to/auth_to.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class LoginApi extends Api {
  final SecurityService _securityService;
  final LoginService _loginService;
  LoginApi(this._securityService, this._loginService);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    router.post('/login', (Request req) async {
      var body = await req.readAsString();
      if (body.isEmpty) {
        return Response(400, body: '{"error": "Empty body"}');
      }

      var authTO = AuthTo.fromRequest(body);

      var userID = await _loginService.authenticate(authTO);
      if (userID > 0) {
        var jwt = await _securityService.generateJWT(userID.toString());
        return Response.ok(jsonEncode({'token': jwt}));
      } else {
        return Response(401, body: '{"error": "Invalid credentials"}');
      }
    });

    return createHandler(router: router.call, middlewares: middlewares);
  }
}
