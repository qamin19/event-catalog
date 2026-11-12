import 'dart:convert';
import 'dart:io';

import 'package:event_catalog/application/use_cases/cancel_event_use_case.dart';
import 'package:event_catalog/application/use_cases/create_event_use_case.dart';
import 'package:event_catalog/application/use_cases/get_all_events_use_case.dart';
import 'package:event_catalog/domain/interfaces/event_repository.dart';
import 'package:event_catalog/infrastructure/repositories/in_memory_event_repository.dart';
import 'package:event_catalog/infrastructure/repositories/json_event_repository.dart';
import 'package:event_catalog/presentation/cli/cli_app.dart';

Future<void> main() async {
  // 1. Читаємо конфігурацію
  final config = _loadConfig('config.json');

  // 2. Створюємо конкретну реалізацію, але тип залишається абстракцією
  final EventRepository repository = _createRepository(config);

  // 3. Передаємо репозиторій у use cases через конструктор (DI)
  final app = CliApp(
    createEvent: CreateEventUseCase(repository),
    getAllEvents: GetAllEventsUseCase(repository),
    cancelEvent: CancelEventUseCase(repository),
  );

  // 4. Запускаємо інтерфейс
  await app.run();
}

Map<String, dynamic> _loadConfig(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    return {'storage': 'memory'};
  }
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

EventRepository _createRepository(Map<String, dynamic> config) {
  switch (config['storage']) {
    case 'json':
      final path = config['filePath'] as String? ?? 'events.json';
      final dir = File(path).parent;
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      return JsonEventRepository(path);
    default:
      return InMemoryEventRepository();
  }
}
