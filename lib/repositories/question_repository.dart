// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';
import 'package:question_board_mobile/models/VoteModel.dart';
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
      String? authToken = await storage.read(key: "token");
      String path = "";
      if (authToken == null) {
        path = "question/anon_create/${eventModel.id}";
      } else {
        path = "question/create/${eventModel.id}";
      }

      Response? response = await _requestServices.sendRequest(
        path: path,
        isToken: true,
        payload: payload,
      );

      dynamic responseJson = _requestServices.returnResponse(
        response!,
        context,
      );

      if (responseJson == null) return null;

      QuestionModel questionModel;
      questionModel = QuestionModel.fromJson(responseJson["question"]);
      return questionModel;
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
      String path =
          "question/answered/${questionModel.eventId}/${questionModel.id}";

      Response? response = await _requestServices.sendRequest(
        path: path,
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

  Future<Vote?> vote({
    required BuildContext context,
    required QuestionModel questionModel,
    required Map payload,
  }) async {
    try {
      const storage = FlutterSecureStorage();
      String? authToken = await storage.read(key: "token");
      String path = "";

      if (authToken == null) {
        path = "question/anon_vote/${questionModel.id}";
      } else {
        path = "question/vote/${questionModel.id}";
      }

      Response? response = await _requestServices.sendRequest(
        path: path,
        isToken: true,
        payload: {},
      );

      dynamic responseJson = _requestServices.returnResponse(
        response!,
        context,
      );

      if (responseJson == null) return null;

      Vote vote = Vote.fromJson(responseJson["vote"]);

      return vote;
    } catch (e) {
      return null;
    }
  }
}
