import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:question_board_mobile/style/colors.dart';
import 'package:question_board_mobile/utils/constants/constants.dart';
import 'package:http/http.dart' as http;

class RequestServices {
  Future<Response?> sendRequest({
    required String path,
    required Map payload,
    required bool isToken,
  }) async {
    try {
      final storage = new FlutterSecureStorage();
      //print("PAYLOADS : $payload");
      Response response;
      Map<String, String> my_header = {
        'Accept': "application/json",
      };
      Uri uri = Uri.parse(Constants.API_URL + path);

      if (isToken) {
        String? auth_token = await storage.read(key: "token");

        my_header = {
          'Accept': "application/json",
          "Authorization": "Bearer $auth_token",
        };
      }
      /*if (isToken) {
      my_header = {'Accept': "application/json", "Authorization": "Bearer $token", "Token": "Bearer $token"};
    }*/

      http.MultipartRequest m_request;
      http.Request request;

/*       if (files != null) {
        if (files.isNotEmpty) {
          m_request = http.MultipartRequest("POST", uri);

          for (var item in files) {
            if (item.devicePath != null) {
              File file = File(item.devicePath!);
              // ignore: deprecated_member_use
              var stream =
                  http.ByteStream(DelegatingStream.typed(file.openRead()));
              var length = await file.length();
              var multipartFile = http.MultipartFile(
                "File[]",
                stream,
                length,
                filename: basename(file.path),
              );
              m_request.files.add(multipartFile);
            }
          }
          Map<String, String> newPayload =
              payload.map((key, value) => MapEntry(key, value.toString()));
          m_request.fields.addAll(newPayload);
          m_request.headers.addAll(my_header);
          var response = await m_request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          return http.Response.bytes(responseData, response.statusCode);
        }
      } else {
        var response = await http.post(uri, headers: my_header, body: payload);
        return response;
      } */

      response = await http.post(uri, headers: my_header, body: payload);
      return response;
    } catch (error) {
      print(error);
      return null;
    }
  }

  dynamic returnResponse(http.Response response, context) {
    switch (response.statusCode) {
      case 200:
        if (jsonDecode(response.body)['status'] == 0) {
          return showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: AppColors.greyColorBottomSheet,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Kapat",
                      style: TextStyle(
                        color: AppColors.buttonColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
                title: Text(
                  jsonDecode(response.body)["errors"],
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          );
        } else {
          dynamic responseJson = jsonDecode(response.body);
          return responseJson;
        }
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        break;
      case 401:
        return null;
      case 403:
        break;
      case 500:
      case 302:
      case 422:
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.greyColorBottomSheet,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Kapat",
                    style: TextStyle(
                      color: AppColors.buttonColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
              title: Text(
                jsonDecode(response.body)['message'],
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        );
        break;
      default:
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.greyColorBottomSheet,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Kapat",
                    style: TextStyle(
                      color: AppColors.buttonColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
              title: Text(
                'Sunucuya şu anda ulaşılamıyor.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        );
        break;
    }
  }
}
