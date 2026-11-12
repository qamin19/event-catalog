import 'dart:convert';
import 'dart:io';

import '../../domain/entities/event_item.dart';
import '../../domain/interfaces/event_repository.dart';

/// Реалізація сховища у вигляді JSON-файлу.
class JsonEventRepository implements EventRepository {
  final File _file;

  JsonEventRepository(String path) : _file = File(path);

  Future<List<EventItem>> _readAll() async {
    if (!await _file.exists()) return [];
    final content = await _file.readAsString();
    if (content.trim().isEmpty) return [];

    final list = jsonDecode(content) as List<dynamic>;
    return list.map((e) => _fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> _writeAll(List<EventItem> events) async {
    final json = events.map(_toJson).toList();
    await _file.writeAsString(const JsonEncoder.withIndent('  ').convert(json));
  }

  Map<String, dynamic> _toJson(EventItem e) => {
    'id': e.id,
    'title': e.title,
    'description': e.description,
    'date': e.date.toIso8601String(),
    'location': e.location,
    'isCancelled': e.isCancelled,
  };

  EventItem _fromJson(Map<String, dynamic> m) => EventItem(
    id: m['id'] as int,
    title: m['title'] as String,
    description: m['description'] as String,
    date: DateTime.parse(m['date'] as String),
    location: m['location'] as String,
    isCancelled: m['isCancelled'] as bool,
  );

  @override
  Future<List<EventItem>> getAll() => _readAll();

  @override
  Future<EventItem?> getById(int id) async {
    final events = await _readAll();
    for (final e in events) {
      if (e.id == id) return e;
    }
    return null;
  }

  @override
  Future<void> save(EventItem event) async {
    final events = await _readAll();
    final index = events.indexWhere((e) => e.id == event.id);
    if (index >= 0) {
      events[index] = event;
    } else {
      events.add(event);
    }
    await _writeAll(events);
  }

  @override
  Future<int> nextId() async {
    final events = await _readAll();
    if (events.isEmpty) return 1;
    return events.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}
