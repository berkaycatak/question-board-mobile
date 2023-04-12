import 'package:flutter/material.dart';
import 'package:question_board_mobile/models/PeopleModel.dart';
import 'package:question_board_mobile/repositories/auth_repository.dart';

class AuthViewModel with ChangeNotifier {
  PeopleModel? peopleModel;

  Future<bool> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
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
    notifyListeners();
    return peopleModel == null ? false : true;
  }

  Future<bool> register(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
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
    notifyListeners();
    return peopleModel == null ? false : true;
  }

  Future<bool> splash(BuildContext context) async {
    UserRepository userRepository = UserRepository();

    peopleModel = await userRepository.splash(
      context: context,
    );
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
}
