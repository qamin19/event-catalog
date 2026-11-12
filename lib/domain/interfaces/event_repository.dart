import '../entities/event_item.dart';

/// Контракт сховища подій.
/// Описується в Domain, реалізується в Infrastructure.
abstract class EventRepository {
  /// Повертає всі події.
  Future<List<EventItem>> getAll();

  /// Повертає подію за id або null, якщо її немає.
  Future<EventItem?> getById(int id);

  /// Зберігає нову або оновлену подію.
  Future<void> save(EventItem event);

  /// Повертає наступний вільний id.
  Future<int> nextId();
}
