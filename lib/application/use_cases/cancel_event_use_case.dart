import '../../domain/entities/event_item.dart';
import '../../domain/exceptions/domain_exception.dart';
import '../../domain/interfaces/event_repository.dart';

/// Use case: скасувати подію за id.
class CancelEventUseCase {
  final EventRepository _repository;

  CancelEventUseCase(this._repository);

  Future<EventItem> execute(int id) async {
    final event = await _repository.getById(id);
    if (event == null) {
      throw DomainException('Подію з id=$id не знайдено');
    }

    final cancelled = event.cancel();
    await _repository.save(cancelled);
    return cancelled;
  }
}
