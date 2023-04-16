import 'package:flutter/material.dart';
import 'package:question_board_mobile/helpers/helpers.dart';
import 'package:question_board_mobile/models/PeopleModel.dart';
import 'package:question_board_mobile/repositories/auth_repository.dart';
import 'package:question_board_mobile/utils/enums/screen_status.dart';

class AuthViewModel with ChangeNotifier {
  PeopleModel? peopleModel;
  String? userIpv4;

  ScreenStatus screenStatus = ScreenStatus.SUCCESS;

  Future<bool> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      changeScreenStatus(ScreenStatus.LOADING);

      UserRepository userRepository = UserRepository();

      Map payload = {
        "email": email,
        "password": password,
      };

      peopleModel = await userRepository.login(
        context: context,
        isToken: false,
        payload: payload,
      );
      changeScreenStatus(ScreenStatus.SUCCESS);
      notifyListeners();

      return peopleModel == null ? false : true;
    } catch (e) {
      changeScreenStatus(ScreenStatus.SUCCESS);
      return false;
    }
  }

  Future<bool> register(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      changeScreenStatus(ScreenStatus.LOADING);

      UserRepository userRepository = UserRepository();

      Map payload = {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };

      peopleModel = await userRepository.register(
        context: context,
        isToken: false,
        payload: payload,
      );

      changeScreenStatus(ScreenStatus.SUCCESS);
      notifyListeners();
      return peopleModel == null ? false : true;
    } catch (e) {
      changeScreenStatus(ScreenStatus.SUCCESS);
      return false;
    }
  }

  Future<bool> splash(BuildContext context) async {
    UserRepository userRepository = UserRepository();

    peopleModel = await userRepository.splash(
      context: context,
    );

    userIpv4 = await Helpers.getIpV4();
    notifyListeners();
    return peopleModel == null ? false : true;
  }

  Future<bool> logout(BuildContext context) async {
    UserRepository userRepository = UserRepository();

    bool status = await userRepository.logout(
      context: context,
    );

    return status;
  }

  changeScreenStatus(ScreenStatus _screenStatus) {
    screenStatus = _screenStatus;

    Future.microtask(() {
      notifyListeners();
    });
  }
}
