import 'package:base_backend/infra/depedency_injector/dependency_injector.dart';
import 'package:base_backend/infra/security/security_service.dart';
import 'package:shelf/shelf.dart';

abstract class Api {
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    int? requiredRole,
  });

  Handler createHandler({
    required Handler router,
    List<Middleware>? middlewares,
    bool isSecurity = false,
    int? requiredRole,
  }) {
    middlewares ??= [];

    if (isSecurity) {
      var securityService = DependencyInjector().get<SecurityService>();
      middlewares.addAll([
        securityService.authorization,
        securityService.verifyJwt,
      ]);

      // Se tiver role obrigatória, adiciona o middleware de verificação
      if (requiredRole != null) {
        middlewares.add(securityService.requireRole(requiredRole));
      }
    }

    var pipeline = Pipeline();
    for (var m in middlewares) {
      pipeline = pipeline.addMiddleware(m);
    }
    return pipeline.addHandler(router);
  }
}
