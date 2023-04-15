import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/helpers/helpers.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';

Widget questionWidget(
  BuildContext context, {
  required QuestionModel question,
}) {
  var _authProvider = Provider.of<AuthViewModel>(context, listen: false);

  return Container(
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(.05),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: '💬 ${_getDateDifference(question.createdAt!)}',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' ${_getSenderName(question)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              const TextSpan(
                text: ' tarafından gönderildi.',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
        SelectableText(question.question!),
        const SizedBox(height: 5),
        Row(
          children: [
            InkWell(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black, width: .5),
                ),
                child: Text(
                  "+${question.votes!.length}",
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            if (_authProvider.peopleModel != null)
              if (question.event!.createdUserId ==
                  _authProvider.peopleModel!.id)
                SizedBox(
                  height: 25,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Cevaplandı",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
          ],
        )
      ],
    ),
  );
}

String _getDateDifference(String date) {
  return Helpers.getTimeDifference(DateTime.parse(date));
}

String _getSenderName(QuestionModel question) {
  if (question.isAnonim == 1) {
    if (question.name != null) {
      return question.name!;
    }
    return "anonim";
  } else {
    return question.user!.name!;
  }
}
