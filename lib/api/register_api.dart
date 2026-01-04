import 'dart:convert';
import 'package:base_backend/api/api.dart';
import 'package:base_backend/models/user_model.dart';
import 'package:base_backend/service/user_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class RegisterApi extends Api {
  final UserService _userService;
  RegisterApi(this._userService);

  @override
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    List<int>? requiredRole,
  }) {
    Router router = Router();
    router.post('/register', (Request req) async {
      var body = await req.readAsString();
      if (body.isEmpty) {
        return Response(400, body: '{"error": "Empty body"}');
      }

      var user = UserModel.fromRequest(jsonDecode(body));
      var result = await _userService.save(user);
      return result
          ? Response(201, body: '{"message": "User created"}')
          : Response.internalServerError(body: '{"error": "Error creating"}');
    });
    return createHandler(
      router: router.call,
      isSecurity: isSecurity,
      middlewares: middlewares,
      requiredRole: requiredRole,
    );
  }
}
