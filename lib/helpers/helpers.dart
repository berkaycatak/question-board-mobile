import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';
import 'package:question_board_mobile/models/VoteModel.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';

class Helpers {
  static String getTimeDifference(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'şimdi';
    }
  }

  static dateToApiFormat(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static Future<String> getIpV4() async {
    final ipv4 = await Ipify.ipv4();
    return ipv4;
  }

  static getUserId(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);

    if (authProvider.peopleModel != null) {
      return authProvider.peopleModel!.id;
    }

    return null;
  }

  static String getUserIdOrIpV4(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);

    int userId = getUserId(context);
    if (userId != null) {
      return userId.toString();
    }

    return authProvider.userIpv4 ?? "";
  }

  static bool isQuestionVoted(
    BuildContext context, {
    required QuestionModel questionModel,
  }) {
    List<Vote> votes = questionModel.votes ?? [];
    dynamic userId = getUserIdOrIpV4(context).toString();

    return votes.where((element) {
      return element.userId == userId;
    }).isNotEmpty;
  }

  static String getQuestionSenderName(QuestionModel question) {
    if (question.isAnonim == 1) {
      if (question.name != null) {
        return question.name!;
      }
      return "anonim";
    } else {
      return question.user!.name!;
    }
  }
}
