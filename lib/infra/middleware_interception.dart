import 'package:shelf/shelf.dart';

class MiddlewareInterception {
  // Middleware que adiciona Content-Type Json em todas as respostas
  static Middleware get contentTypeJson => createMiddleware(
    responseHandler: (Response res) =>
        res.change(headers: {'content-type': 'application/json'}),
  );

  static Middleware get cors {
    final headerPermission = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
    };
    Response? handlerOptions(Request req) {
      if (req.method == 'OPTIONS') {
        return Response.ok('', headers: headerPermission);
      }
      return null;
    }

    Response addCrosHeaders(Response res) =>
        res.change(headers: headerPermission);
    return createMiddleware(
      requestHandler: handlerOptions,
      responseHandler: addCrosHeaders,
    );
  }
}
