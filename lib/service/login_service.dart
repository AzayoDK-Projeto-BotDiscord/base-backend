import 'package:base_backend/service/user_service.dart';
import 'package:base_backend/to/auth_to.dart';
import 'package:dbcrypt/dbcrypt.dart';

class LoginService {
  final UserService _userService;
  LoginService(this._userService);

  // Retorna o ID do usuário se autenticado, ou -1 se falhar
  Future<int> authenticate(AuthTo to) async {
    try {
      var user = await _userService.findByEmail(to.email);
      if (user == null) return -1;
      bool correctPassword = DBCrypt().checkpw(to.password, user.password!);
      return correctPassword ? user.id! : -1;
    } catch (e) {
      print('[ERROR] -> Authentication failed: ${to.email}');
      return -1;
    }
  }
}
