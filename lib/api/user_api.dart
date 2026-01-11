import 'dart:convert';
import 'package:base_backend/api/api.dart';
import 'package:base_backend/models/user_model.dart';
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

    router.put('/user/iduserdiscord', (Request req) async {
      var body = await req.readAsString();
      if (body.isEmpty) {
        return Response(400, body: '{"error": "Empty body"}');
      }
      var user = UserModel.fromUpdateIdDiscord(jsonDecode(body));
      var result = await _userService.updateIdUserDiscord(user);
      return result
          ? Response(201, body: '{"message": "recorded id discord"}')
          : Response.internalServerError(
              body: '{"error": "error registering the id discord"}',
            );
    });

    return createHandler(
      router: router.call,
      isSecurity: isSecurity,
      middlewares: middlewares,
      requiredRole:
          requiredRole ?? [1], // Por padrão, só admin (1) pode acessar
    );
  }
}
