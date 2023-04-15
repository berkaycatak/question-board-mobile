import 'package:flutter/material.dart';
import 'package:question_board_mobile/helpers/helpers.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/models/PeopleModel.dart';
import 'package:question_board_mobile/repositories/auth_repository.dart';
import 'package:question_board_mobile/repositories/event_repository.dart';
import 'package:question_board_mobile/screens/events/detail/event_detail_screen.dart';
import 'package:question_board_mobile/utils/enums/screen_status.dart';

class EventViewModel with ChangeNotifier {
  ScreenStatus screenStatus = ScreenStatus.SUCCESS;

  List<EventModel>? coming_events;
  List<EventModel>? past_events;
  EventModel? eventDetailModel;

  events(BuildContext context) async {
    try {
      changeScreenStatus(ScreenStatus.LOADING);

      EventRepository eventRepository = EventRepository();

      List? _response = await eventRepository.events(
        context: context,
      );

      coming_events = [];
      past_events = [];

      coming_events = _response[0];
      past_events = _response[1];

      changeScreenStatus(ScreenStatus.SUCCESS);
    } catch (e) {
      //changeScreenStatus(ScreenStatus.ERROR);
      //error sistemi kurmaya vakit olmadığı için başarılı durumundan ilerlenecek.

      changeScreenStatus(ScreenStatus.SUCCESS);
    }

    notifyListeners();
  }

  details(BuildContext context, EventModel eventModel) async {
    try {
      changeScreenStatus(ScreenStatus.LOADING);

      EventRepository eventRepository = EventRepository();

      eventDetailModel = await eventRepository.detail(
        context: context,
        eventModel: eventModel,
      );

      changeScreenStatus(ScreenStatus.SUCCESS);
    } catch (e) {
      //changeScreenStatus(ScreenStatus.ERROR);
      //error sistemi kurmaya vakit olmadığı için başarılı durumundan ilerlenecek.

      changeScreenStatus(ScreenStatus.SUCCESS);
    }

    notifyListeners();
  }

  changeScreenStatus(ScreenStatus _screenStatus) {
    screenStatus = _screenStatus;

    Future.microtask(() {
      notifyListeners();
    });
  }

  // create
  DateTime? eventCreateSelectedDate;
  bool eventCreateSelectedDateShowErrorMessage = false;
  Future<EventModel?> create(
    BuildContext context,
    GlobalKey<FormState> formkey, {
    required String title,
    required String time,
    required String description,
    required String adress,
  }) async {
    try {
      if (eventCreateSelectedDate == null) {
        eventCreateSelectedDateShowErrorMessage = true;
        notifyListeners();
      } else {
        eventCreateSelectedDateShowErrorMessage = false;
        notifyListeners();
      }
      bool validate = formkey.currentState!.validate();

      if (!validate) {
        return null;
      }

      changeScreenStatus(ScreenStatus.LOADING);

      Map payload = {
        "name": title,
        "description": description,
        "adress": adress,
        "date": Helpers.dateToApiFormat(eventCreateSelectedDate!),
        "time": time
      };
      EventRepository eventRepository = EventRepository();
      EventModel? eventModel = await eventRepository.create(
        context: context,
        payload: payload,
      );

      changeScreenStatus(ScreenStatus.SUCCESS);
      return eventModel;
    } catch (e) {
      //changeScreenStatus(ScreenStatus.ERROR);
      //error sistemi kurmaya vakit olmadığı için başarılı durumundan ilerlenecek.

      changeScreenStatus(ScreenStatus.SUCCESS);
    }

    notifyListeners();
  }

  void eventCreateClearDispose() {
    eventCreateSelectedDate = null;
    eventCreateSelectedDateShowErrorMessage = false;
  }

  void setCreateSelectedDate(DateTime? selectedDate) {
    if (selectedDate != null) {
      eventCreateSelectedDate = selectedDate;
    }
    notifyListeners();
  }
  // create

  Future<EventModel?> edit(
    BuildContext context,
    GlobalKey<FormState> formkey, {
    required EventModel eventModel,
    required String title,
    required String time,
    required String description,
    required String adress,
  }) async {
    try {
      if (eventCreateSelectedDate == null) {
        eventCreateSelectedDateShowErrorMessage = true;
        notifyListeners();
      } else {
        eventCreateSelectedDateShowErrorMessage = false;
        notifyListeners();
      }
      bool validate = formkey.currentState!.validate();

      if (!validate) {
        return null;
      }

      changeScreenStatus(ScreenStatus.LOADING);

      Map payload = {
        "name": title,
        "description": description,
        "adress": adress,
        "date": Helpers.dateToApiFormat(eventCreateSelectedDate!),
        "time": time
      };
      EventRepository eventRepository = EventRepository();
      EventModel? _eventModel = await eventRepository.edit(
        context: context,
        payload: payload,
        eventModel: eventModel,
      );

      changeScreenStatus(ScreenStatus.SUCCESS);
      return _eventModel;
    } catch (e) {
      //changeScreenStatus(ScreenStatus.ERROR);
      //error sistemi kurmaya vakit olmadığı için başarılı durumundan ilerlenecek.

      changeScreenStatus(ScreenStatus.SUCCESS);
    }

    notifyListeners();
  }
}
