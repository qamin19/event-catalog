import '../../domain/entities/event_item.dart';
import '../../domain/interfaces/event_repository.dart';

/// Реалізація сховища в оперативній пам'яті (для тестів і демо).
class InMemoryEventRepository implements EventRepository {
  final Map<int, EventItem> _storage = {};
  int _lastId = 0;

  @override
  Future<List<EventItem>> getAll() async => _storage.values.toList();

  @override
  Future<EventItem?> getById(int id) async => _storage[id];

  @override
  Future<void> save(EventItem event) async {
    _storage[event.id] = event;
  }

  @override
  Future<int> nextId() async => ++_lastId;
}
