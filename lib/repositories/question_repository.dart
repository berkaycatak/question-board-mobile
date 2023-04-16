// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';
import 'package:question_board_mobile/services/request_services.dart';

class QuestionRepository {
  final RequestServices _requestServices = RequestServices();

  Future<QuestionModel?> create({
    required BuildContext context,
    required Map payload,
    required EventModel eventModel,
  }) async {
    try {
      const storage = FlutterSecureStorage();
      String? auth_token = await storage.read(key: "token");
      String _path = "";
      if (auth_token == null) {
        _path = "question/anon_create/${eventModel.id}";
      } else {
        _path = "question/create/${eventModel.id}";
      }

      Response? response = await _requestServices.sendRequest(
        path: _path,
        isToken: true,
        payload: payload,
      );

      dynamic responseJson = _requestServices.returnResponse(
        response!,
        context,
      );

      if (responseJson == null) return null;

      QuestionModel _questionModel;
      _questionModel = QuestionModel.fromJson(responseJson["question"]);
      return _questionModel;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> answer({
    required BuildContext context,
    required QuestionModel questionModel,
  }) async {
    try {
      String _path =
          "question/answered/${questionModel.eventId}/${questionModel.id}";

      Response? response = await _requestServices.sendRequest(
        path: _path,
        isToken: true,
        payload: {},
      );

      dynamic responseJson = _requestServices.returnResponse(
        response!,
        context,
      );

      if (responseJson == null) return false;

      bool status = responseJson["status"] == 1 ? true : false;

      return status;
    } catch (e) {
      return false;
    }
  }
}
