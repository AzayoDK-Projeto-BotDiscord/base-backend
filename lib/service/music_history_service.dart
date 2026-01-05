import 'package:base_backend/dao/music_history_dao.dart';
import 'package:base_backend/models/music_history_model.dart';
import 'package:base_backend/service/generic_service.dart';

class MusicHistoryService implements GenericService<MusicHistoryModel> {
  final MusicHistoryDao _musicHistoryDao;
  MusicHistoryService(this._musicHistoryDao);

  @override
  Future<bool> delete(int id) async => _musicHistoryDao.delete(id);

  @override
  Future<List<MusicHistoryModel>> findAll() async =>
      _musicHistoryDao.findeAll();

  @override
  Future<MusicHistoryModel?> findOne(int id) async =>
      _musicHistoryDao.findeOne(id);

  @override
  Future<bool> save(MusicHistoryModel value) async =>
      _musicHistoryDao.create(value);

  Future<List<MusicHistoryModel>> findAllByUserDiscord(
    String idUserDiscord,
  ) async => _musicHistoryDao.findAllByUserDiscord(idUserDiscord);

  Future<List<MusicHistoryModel>> findAllByDiscordServer(
    String idDiscordServer,
  ) async => _musicHistoryDao.findAllByDiscordServer(idDiscordServer);
}
