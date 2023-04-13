// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/models/PeopleModel.dart';
import 'package:question_board_mobile/services/request_services.dart';

class EventRepository {
  final RequestServices _requestServices = RequestServices();
  String? authBarrier;

  Future<List> events({required BuildContext context}) async {
    const storage = FlutterSecureStorage();
    String? auth_token = await storage.read(key: "token");
    String _path = "anon-event/list";

    if (auth_token != null) String _path = "event/list";

    Response? response = await _requestServices.sendRequest(
      path: _path,
      isToken: true,
      payload: {},
    );

    dynamic responseJson = _requestServices.returnResponse(response!, context);

    if (responseJson == null) return [];

    List<EventModel> coming_events = [];
    List<EventModel> past_events = [];

    List<dynamic> _comingEvents = responseJson["events"]["coming"];
    _comingEvents.forEach((element) {
      coming_events.add(EventModel.fromJson(element));
    });

    List<dynamic> _pastEvents = responseJson["events"]["past"];
    _pastEvents.forEach((element) {
      past_events.add(EventModel.fromJson(element));
    });

    return [
      coming_events,
      past_events,
    ];
  }

  Future<EventModel?> detail(
      {required BuildContext context, required EventModel eventModel}) async {
    try {
      const storage = FlutterSecureStorage();
      String? auth_token = await storage.read(key: "token");
      String _path = "anon-event/show/${eventModel.id}";

      if (auth_token != null) String _path = "event/show/${eventModel.id}";

      Response? response = await _requestServices.sendRequest(
        path: _path,
        isToken: true,
        payload: {},
      );

      dynamic responseJson =
          _requestServices.returnResponse(response!, context);

      if (responseJson == null) return null;

      EventModel _eventModel;
      _eventModel = EventModel.fromJson(responseJson["event"]);
      return _eventModel;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
