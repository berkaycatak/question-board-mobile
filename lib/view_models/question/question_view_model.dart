import 'package:flutter/material.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';
import 'package:question_board_mobile/repositories/question_repository.dart';
import 'package:question_board_mobile/utils/enums/screen_status.dart';

class QuestionViewModel with ChangeNotifier {
  ScreenStatus screenStatus = ScreenStatus.SUCCESS;
  ScreenStatus deleteScreenStatus = ScreenStatus.SUCCESS;

  changeScreenStatus(ScreenStatus _screenStatus) {
    screenStatus = _screenStatus;

    Future.microtask(() {
      notifyListeners();
    });
  }

  changeDeleteScreenStatus(ScreenStatus _deleteScreenStatus) {
    deleteScreenStatus = _deleteScreenStatus;

    Future.microtask(() {
      notifyListeners();
    });
  }

  Future<QuestionModel?> create(
    BuildContext context, {
    required String question,
    required String name,
    required EventModel eventModel,
  }) async {
    try {
      changeScreenStatus(ScreenStatus.LOADING);

      Map payload = {
        "name": name,
        "question": question,
      };

      QuestionRepository questionRepository = QuestionRepository();
      QuestionModel? questionModel = await questionRepository.create(
        context: context,
        payload: payload,
        eventModel: eventModel,
      );

      changeScreenStatus(ScreenStatus.SUCCESS);
      return questionModel;
    } catch (e) {
      //changeScreenStatus(ScreenStatus.ERROR);
      //error sistemi kurmaya vakit olmadığı için başarılı durumundan ilerlenecek.

      changeScreenStatus(ScreenStatus.SUCCESS);
    }

    notifyListeners();
  }

  Future<bool> answer(
    BuildContext context, {
    required QuestionModel questionModel,
  }) async {
    try {
      changeScreenStatus(ScreenStatus.LOADING);

      QuestionRepository questionRepository = QuestionRepository();
      bool response = await questionRepository.answer(
        context: context,
        questionModel: questionModel,
      );

      notifyListeners();
      changeScreenStatus(ScreenStatus.SUCCESS);
      return response;
    } catch (e) {
      notifyListeners();
      changeScreenStatus(ScreenStatus.SUCCESS);
      return false;
    }
  }
}
