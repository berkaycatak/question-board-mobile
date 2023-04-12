// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:question_board_mobile/models/PeopleModel.dart';
import 'package:question_board_mobile/services/request_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final RequestServices _requestServices = RequestServices();
  String? authBarrier;

  Future<PeopleModel?> login({
    required BuildContext context,
    required Map payload,
    required bool isToken,
  }) async {
    Response? response = await _requestServices.sendRequest(
      path: "login",
      isToken: isToken,
      payload: payload,
    );

    dynamic responseJson = _requestServices.returnResponse(response!, context);

    if (responseJson == null) return null;

    PeopleModel people = PeopleModel.fromJson(responseJson["user"]);

    const storage = FlutterSecureStorage();
    await storage.write(key: "token", value: responseJson["token"]);

    return people;
  }

  Future<PeopleModel?> register({
    required BuildContext context,
    required Map payload,
    required bool isToken,
  }) async {
    Response? response = await _requestServices.sendRequest(
      path: "register",
      isToken: isToken,
      payload: payload,
    );

    dynamic responseJson = _requestServices.returnResponse(response!, context);

    if (responseJson == null) return null;

    PeopleModel people = PeopleModel.fromJson(responseJson["user"]);

    const storage = FlutterSecureStorage();
    await storage.write(key: "token", value: responseJson["token"]);

    return people;
  }

  Future<bool> logout({
    required BuildContext context,
  }) async {
    Response? response = await _requestServices.sendRequest(
      path: "logout",
      isToken: true,
      payload: {},
    );

    dynamic responseJson = _requestServices.returnResponse(response!, context);

    if (responseJson == null) return false;

    const storage = FlutterSecureStorage();
    await storage.delete(key: "token");

    return true;
  }

  Future<PeopleModel?> splash({
    required BuildContext context,
  }) async {
    Response? response = await _requestServices.sendRequest(
      path: "splash",
      isToken: true,
      payload: {},
    );

    dynamic responseJson = _requestServices.returnResponse(response!, context);

    if (responseJson == null) return null;

    PeopleModel people = PeopleModel.fromJson(responseJson["user"]);

    const storage = FlutterSecureStorage();
    await storage.write(key: "token", value: responseJson["token"]);

    return people;
  }
}
