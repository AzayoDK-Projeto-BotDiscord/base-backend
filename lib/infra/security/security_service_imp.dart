import 'package:base_backend/infra/security/security_service.dart';
import 'package:base_backend/utils/custom_env.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

class SecurityServiceImp implements SecurityService<JWT> {
  @override
  Future<String> generateJWT(String userID) async {
    // Cria o payload do token
    var jwt = JWT({
      'iat': DateTime.now().millisecondsSinceEpoch,
      'userID': userID,
      'roles': ['user', 'admin'],
    });

    // Obtém a chave secreta do .env
    String key = await CustomEnv.get<String>(key: 'JWT_SECRET');

    String token = jwt.sign(SecretKey(key));
    return token;
  }

  @override
  Future<JWT?> validateJWT(String token) async {
    String key = await CustomEnv.get<String>(key: 'JWT_SECRET');

    try {
      return JWT.verify(token, SecretKey(key));
    } on JWTInvalidException {
      return null;
    } on JWTExpiredException {
      return null;
    } on JWTNotActiveException {
      return null;
    } on JWTUndefinedException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Middleware get authorization {
    return (Handler handler) {
      return (Request req) async {
        String? authHeader = req.headers['Authorization'];
        JWT? jwt;

        if (authHeader != null && authHeader.startsWith('Bearer ')) {
          String token = authHeader.substring(7);
          jwt = await validateJWT(token);
        }

        // Adiciona o JWT ao contexto da requisição
        var request = req.change(context: {'jwt': jwt});
        return handler(request);
      };
    };
  }

  @override
  Middleware get verifyJwt => createMiddleware(
    requestHandler: (Request req) {
      if (req.context['jwt'] == null) {
        return Response.forbidden('{"error": "unauthorized"}');
      }
      return null;
    },
  );
}
