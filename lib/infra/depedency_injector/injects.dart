import 'package:base_backend/api/exemplo_api.dart';
import 'package:base_backend/api/segunda_api.dart';
import 'package:base_backend/infra/depedency_injector/dependency_injector.dart';

class Injects {
  static DependencyInjector initialize() {
    var di = DependencyInjector();

    // ═══════════════════════════════════════════════════════════
    // 📌 REGISTRE SUAS DEPENDÊNCIAS AQUI
    // ═══════════════════════════════════════════════════════════

    // APIs
    di.register<ExemploApi>(() => ExemploApi());
    di.register<SegundaApi>(() => SegundaApi());

    return di;
  }
}
