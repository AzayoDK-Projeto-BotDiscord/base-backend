import 'package:base_backend/infra/security/security_service.dart';
import 'package:base_backend/utils/custom_env.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

class SecurityServiceImp implements SecurityService<JWT> {
  @override
  Future<String> generateJWT(
    String userID,
    int idPermission,
    int idStatus,
  ) async {
    // Cria o payload do token com a role do usuário
    var jwt = JWT({
      'iat': DateTime.now().millisecondsSinceEpoch,
      'exp': DateTime.now().add(Duration(hours: 24)).millisecondsSinceEpoch,
      'userID': userID,
      'role': idPermission, // 1 = admin, 2 = user, 3 = bot
      'status': idStatus,
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

  @override
  Middleware requireRoles(List<int> allowedRoles) {
    return createMiddleware(
      requestHandler: (Request req) {
        JWT? jwt = req.context['jwt'] as JWT?;

        if (jwt == null) {
          return Response.forbidden('{"error": "unauthorized"}');
        }

        int? userRole = jwt.payload['role'] as int?;

        // Admin (1) sempre tem acesso
        if (userRole == 1) {
          return null;
        }

        // Verifica se a role do usuário está na lista de roles permitidas
        if (userRole == null || !allowedRoles.contains(userRole)) {
          return Response.forbidden(
            '{"error": "access denied - insufficient permissions"}',
          );
        }

        return null;
      },
    );
  }

  @override
  Middleware get verifyStatus => createMiddleware(
    requestHandler: (Request req) {
      JWT? jwt = req.context['jwt'] as JWT?;

      if (jwt == null) {
        return Response.forbidden('{"error": "unauthorized"}');
      }

      int? status = jwt.payload['status'] as int?;

      // Verificar o status do usuario
      switch (status) {
        case 1: // ativo
          return null;
        case 2: // Inativo
          return Response.forbidden(
            '{"error": "user_inactive", "message": "Your account is inactive. Please contact support."}',
          );
        case 3: // bloqueado
          return Response.forbidden(
            '{"error": "user_blocked", "message": "Your account has been blocked for security reasons."}',
          );
        default:
          return Response.forbidden(
            '{"error": "invalid_status", "message": "Invalid user status."}',
          );
      }
    },
  );
}
