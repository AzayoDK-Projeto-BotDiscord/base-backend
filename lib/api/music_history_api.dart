import 'dart:convert';

import 'package:base_backend/api/api.dart';
import 'package:base_backend/models/music_history_model.dart';
import 'package:base_backend/service/music_history_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class MusicHistoryApi extends Api {
  final MusicHistoryService _musicHistoryService;
  MusicHistoryApi(this._musicHistoryService);

  @override
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
    List<int>? requiredRole,
  }) {
    Router router = Router();
    // Rota para receber historico /music/history/user?id=123141
    router.get('/music/history/user', (Request req) async {
      String? idUserDiscord = req.url.queryParameters['id'];
      if (idUserDiscord == null) return Response(400);

      var musics = await _musicHistoryService.findAllByUserDiscord(
        idUserDiscord,
      );
      if (musics.isEmpty) return Response(404);
      var musicMap = musics.map((m) => m.toJson()).toList();
      return Response.ok(jsonEncode(musicMap));
    });

    // Rota para receber historico /music/history/server?id=123141
    router.get('/music/history/server', (Request req) async {
      String? idDiscordServer = req.url.queryParameters['id'];
      if (idDiscordServer == null) return Response(400);

      var musics = await _musicHistoryService.findAllByDiscordServer(
        idDiscordServer,
      );
      if (musics.isEmpty) return Response(404);
      var musicMap = musics.map((m) => m.toJson()).toList();
      return Response.ok(jsonEncode(musicMap));
    });

    // Rota para enviar musica
    router.post('/music/history', (Request req) async {
      var body = await req.readAsString();
      if (body.isEmpty) {
        return Response(400, body: '{"error": "Empty body"}');
      }

      var music = MusicHistoryModel.fromRequest(jsonDecode(body));
      var result = await _musicHistoryService.save(music);
      return result
          ? Response(201, body: '{"message": "recorded music"}')
          : Response.internalServerError(
              body: '{"error": "error registering the music"}',
            );
    });

    return createHandler(
      router: router.call,
      isSecurity: isSecurity,
      middlewares: middlewares,
      requiredRole: requiredRole ?? [1],
    );
  }
}
