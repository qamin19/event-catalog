import '../../domain/entities/event_item.dart';
import '../../domain/exceptions/domain_exception.dart';
import '../../domain/interfaces/event_repository.dart';

/// Use case: створити нову подію.
/// Залежить лише від абстракції EventRepository (DIP).
class CreateEventUseCase {
  final EventRepository _repository;

  CreateEventUseCase(this._repository);

  Future<EventItem> execute({
    required String title,
    required String description,
    required DateTime date,
    required String location,
  }) async {
    if (title.trim().isEmpty) {
      throw const DomainException('Назва події не може бути порожньою');
    }

    final id = await _repository.nextId();
    final event = EventItem(
      id: id,
      title: title.trim(),
      description: description.trim(),
      date: date,
      location: location.trim(),
    );

    await _repository.save(event);
    return event;
  }
}
