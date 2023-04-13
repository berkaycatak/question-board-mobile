import 'package:flutter/material.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/models/PeopleModel.dart';
import 'package:question_board_mobile/repositories/auth_repository.dart';
import 'package:question_board_mobile/repositories/event_repository.dart';
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
}
