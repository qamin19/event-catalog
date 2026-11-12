import '../../domain/entities/event_item.dart';
import '../../domain/interfaces/event_repository.dart';

/// Use case: отримати всі події, відсортовані за датою.
class GetAllEventsUseCase {
  final EventRepository _repository;

  GetAllEventsUseCase(this._repository);

  Future<List<EventItem>> execute() async {
    final events = await _repository.getAll();
    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }
}
