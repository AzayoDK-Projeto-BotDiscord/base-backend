import 'package:base_backend/infra/depedency_injector/dependency_injector.dart';
import 'package:base_backend/infra/security/security_service.dart';
import 'package:shelf/shelf.dart';

abstract class Api {
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    List<int>? requiredRole,
  });

  Handler createHandler({
    required Handler router,
    List<Middleware>? middlewares,
    bool isSecurity = false,
    List<int>? requiredRole,
  }) {
    middlewares ??= [];

    if (isSecurity) {
      var securityService = DependencyInjector().get<SecurityService>();
      middlewares.addAll([
        securityService.authorization,
        securityService.verifyJwt,
        securityService.verifyStatus,
      ]);

      // Se tiver roles obrigatórias, adiciona o middleware de verificação
      if (requiredRole != null && requiredRole.isNotEmpty) {
        middlewares.add(securityService.requireRoles(requiredRole));
      }
    }

    var pipeline = Pipeline();
    for (var m in middlewares) {
      pipeline = pipeline.addMiddleware(m);
    }
    return pipeline.addHandler(router);
  }
}
