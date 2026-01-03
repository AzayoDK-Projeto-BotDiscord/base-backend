import 'package:base_backend/api/login_api.dart';
import 'package:base_backend/api/register_api.dart';
import 'package:base_backend/api/user_api.dart';
import 'package:base_backend/dao/user_dao.dart';
import 'package:base_backend/database/db_configuration.dart';
import 'package:base_backend/database/mysql_db_configuration.dart';
import 'package:base_backend/infra/depedency_injector/dependency_injector.dart';
import 'package:base_backend/security/security_service.dart';
import 'package:base_backend/security/security_service_imp.dart';
import 'package:base_backend/service/login_service.dart';
import 'package:base_backend/service/user_service.dart';

class Injects {
  static DependencyInjector initialize() {
    var di = DependencyInjector();

    // ═══════════════════════════════════════════════════════════
    // 📌 REGISTRE SUAS DEPENDÊNCIAS AQUI
    // ═══════════════════════════════════════════════════════════

    // Banco de dados
    di.register<DBConfiguration>(() => MysqlDbConfiguration());

    // Segurança
    di.register<SecurityService>(() => SecurityServiceImp());

    // Usuario
    di.register<UserDao>(() => UserDao(di<DBConfiguration>()));
    di.register<UserService>(() => UserService(di<UserDao>()));
    di.register<UserApi>(() => UserApi(di<UserService>()));

    // Registro
    di.register<RegisterApi>(() => RegisterApi(di<UserService>()));

    // Login
    di.register<LoginService>(() => LoginService(di<UserService>()));
    di.register<LoginApi>(
      () => LoginApi(di<SecurityService>(), di<LoginService>()),
    );

    return di;
  }
}
