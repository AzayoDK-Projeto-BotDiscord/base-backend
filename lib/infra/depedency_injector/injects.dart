import 'package:base_backend/api/exemplo_api.dart';
import 'package:base_backend/api/login_api.dart';
import 'package:base_backend/api/segunda_api.dart';
import 'package:base_backend/database/db_configuration.dart';
import 'package:base_backend/database/mysql_db_configuration.dart';
import 'package:base_backend/infra/depedency_injector/dependency_injector.dart';
import 'package:base_backend/security/security_service.dart';
import 'package:base_backend/security/security_service_imp.dart';

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

    // APIs
    di.register<LoginApi>(() => LoginApi(di<SecurityService>()));
    di.register<ExemploApi>(() => ExemploApi());
    di.register<SegundaApi>(() => SegundaApi());
    return di;
  }
}
