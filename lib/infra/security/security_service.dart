import 'package:shelf/shelf.dart';

abstract class SecurityService<T> {
  Future<String> generateJWT(String userID, int idPermission, int idStatus);
  Future<T?> validateJWT(String token);
  Middleware get authorization;
  Middleware get verifyJwt;
  Middleware get verifyStatus;
  Middleware requireRoles(List<int> allowedRoles);
}
