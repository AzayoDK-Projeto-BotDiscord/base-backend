import 'package:base_backend/dao/user_dao.dart';
import 'package:base_backend/models/user_model.dart';
import 'package:base_backend/service/generic_service.dart';
import 'package:dbcrypt/dbcrypt.dart';

class UserService implements GenericService<UserModel> {
  final UserDao _userDao;
  UserService(this._userDao);

  @override
  Future<bool> delete(int id) async => _userDao.delete(id);

  @override
  Future<List<UserModel>> findAll() async => _userDao.findeAll();

  @override
  Future<UserModel?> findOne(int id) async => _userDao.findeOne(id);

  @override
  Future<bool> save(UserModel value) {
    if (value.id != null) {
      return _userDao.update(value);
    } else {
      final hash = DBCrypt().hashpw(value.password!, DBCrypt().gensalt());
      value.password = hash;
      return _userDao.create(value);
    }
  }

  // Método especifico para o login
  Future<UserModel?> findByEmail(String email) async =>
      _userDao.findByEmail(email);

  // Método para vincular o id do discord com o usuário
  Future<bool> updateIdUserDiscord(UserModel value) async =>
      _userDao.updateIdUserDiscord(value);
}
