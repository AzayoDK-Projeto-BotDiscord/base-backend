import 'dart:convert';
import 'package:base_backend/api/api.dart';
import 'package:base_backend/service/user_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UserApi extends Api {
  final UserService _userService;
  UserApi(this._userService);

  @override
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    List<int>? requiredRole,
  }) {
    Router router = Router();

    router.get('/users', (Request req) async {
      var users = await _userService.findAll();
      var usersMap = users.map((e) => e.toJson()).toList();
      return Response.ok(jsonEncode(usersMap));
    });

    return createHandler(
      router: router.call,
      isSecurity: isSecurity,
      middlewares: middlewares,
      requiredRole: requiredRole ?? [1], // Por padrão, só admin (1) pode acessar
    );
  }
}
