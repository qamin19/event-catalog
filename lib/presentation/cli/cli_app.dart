import 'dart:convert';
import 'dart:io';

import '../../application/use_cases/cancel_event_use_case.dart';
import '../../application/use_cases/create_event_use_case.dart';
import '../../application/use_cases/get_all_events_use_case.dart';
import '../../domain/exceptions/domain_exception.dart';

/// Консольний інтерфейс. Не містить бізнес-логіки:
/// лише читає ввід, викликає use cases і друкує результат.
class CliApp {
  final CreateEventUseCase _createEvent;
  final GetAllEventsUseCase _getAllEvents;
  final CancelEventUseCase _cancelEvent;

  CliApp({
    required CreateEventUseCase createEvent,
    required GetAllEventsUseCase getAllEvents,
    required CancelEventUseCase cancelEvent,
  }) : _createEvent = createEvent,
       _getAllEvents = getAllEvents,
       _cancelEvent = cancelEvent;

  Future<void> run() async {
    while (true) {
      _printMenu();
      final choice = _readLine('Ваш вибір: ');

      try {
        switch (choice) {
          case '1':
            await _addEvent();
          case '2':
            await _listEvents();
          case '3':
            await _cancelEventById();
          case '0':
            print('До побачення!');
            return;
          default:
            print('Невідомий пункт меню.');
        }
      } on DomainException catch (e) {
        print('Помилка: ${e.message}');
      }
    }
  }

  void _printMenu() {
    print('');
    print('=== Каталог подій ===');
    print('1. Додати подію');
    print('2. Показати всі події');
    print('3. Скасувати подію');
    print('0. Вихід');
  }

  Future<void> _addEvent() async {
    final title = _readLine('Назва: ');
    final description = _readLine('Опис: ');
    final date = _parseDate(_readLine('Дата (дд.мм.рррр): '));
    final location = _readLine('Місце: ');

    final event = await _createEvent.execute(
      title: title,
      description: description,
      date: date,
      location: location,
    );
    print('Подію додано: $event');
  }

  Future<void> _listEvents() async {
    final events = await _getAllEvents.execute();
    if (events.isEmpty) {
      print('Подій поки немає.');
      return;
    }
    for (final e in events) {
      print(e);
    }
  }

  Future<void> _cancelEventById() async {
    final id = int.tryParse(_readLine('Id події: '));
    if (id == null) {
      throw const DomainException('Id має бути числом');
    }
    final event = await _cancelEvent.execute(id);
    print('Подію скасовано: $event');
  }

  String _readLine(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync(encoding: utf8)?.trim() ?? '';
  }

  DateTime _parseDate(String input) {
    final parts = input.split('.');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    throw const DomainException('Невірний формат дати, потрібно дд.мм.рррр');
  }
}
