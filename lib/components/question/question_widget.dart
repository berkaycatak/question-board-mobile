import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/helpers/helpers.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';
import 'package:question_board_mobile/components/question/answer/question_is_answered_button_widget.dart';
import 'package:question_board_mobile/components/question/vote/question_vote_button_widget.dart';

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
            text: question.isAnswered == 1 ? '✅' : '💬 ',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' ${Helpers.getTimeDifference(
                  DateTime.parse(question.createdAt!),
                )}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              ),
              TextSpan(
                text: ' ${Helpers.getQuestionSenderName(question)}',
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
            QuestionVoteButtonWidget(question: question),
            const SizedBox(width: 5),
            if (_authProvider.peopleModel != null)
              if (question.event!.createdUserId ==
                  _authProvider.peopleModel!.id)
                QuestionIsAnsweredButtonWidget(question: question),
          ],
        )
      ],
    ),
  );
}
