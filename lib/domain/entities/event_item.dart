/// Сутність "Подія" — центральний об'єкт предметної області.
/// Не залежить від жодного іншого шару.
class EventItem {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final bool isCancelled;

  const EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.isCancelled = false,
  });

  /// Повертає копію події зі скасованим статусом.
  EventItem cancel() {
    return EventItem(
      id: id,
      title: title,
      description: description,
      date: date,
      location: location,
      isCancelled: true,
    );
  }

  @override
  String toString() {
    final status = isCancelled ? 'СКАСОВАНО' : 'активна';
    final d =
        '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.${date.year}';
    return '[$id] $title | $d | $location | $status';
  }
}
