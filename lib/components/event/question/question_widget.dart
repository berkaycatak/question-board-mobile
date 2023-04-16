import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/components/loading_widget.dart';
import 'package:question_board_mobile/helpers/helpers.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';
import 'package:question_board_mobile/models/VoteModel.dart';
import 'package:question_board_mobile/utils/enums/screen_status.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';
import 'package:question_board_mobile/view_models/question/question_view_model.dart';

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
            _voteWidgetBuilder(question: question),
            const SizedBox(width: 5),
            if (_authProvider.peopleModel != null)
              if (question.event!.createdUserId ==
                  _authProvider.peopleModel!.id)
                _IsAnsweredWidgetBuilder(question: question),
          ],
        )
      ],
    ),
  );
}

class _IsAnsweredWidgetBuilder extends StatefulWidget {
  QuestionModel question;
  _IsAnsweredWidgetBuilder({
    super.key,
    required this.question,
  });

  @override
  State<_IsAnsweredWidgetBuilder> createState() =>
      __IsAnsweredWidgetBuilderState();
}

class __IsAnsweredWidgetBuilderState extends State<_IsAnsweredWidgetBuilder> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var questionProvider = Provider.of<QuestionViewModel>(context);

    void answer() async {
      // yükleniyor işlemi provider üzerinden yönetildiğinde tüm sorularda
      // yükleniyor ikonu çıktığı için bu yöntemle halledildi.

      setState(() {
        isLoading = true;
      });

      bool response = await questionProvider.answer(
        context,
        questionModel: widget.question,
      );

      setState(() {
        isLoading = false;
      });

      if (response) {
        setState(() {
          if (widget.question.isAnswered == 1) {
            widget.question.isAnswered = 0;
          } else {
            widget.question.isAnswered = 1;
          }
        });
      }
    }

    return SizedBox(
      height: 25,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              widget.question.isAnswered == 1 ? Colors.black : Colors.green,
        ),
        onPressed: isLoading ? null : () async => answer(),
        child: isLoading
            ? loadingWidget()
            : widget.question.isAnswered == 1
                ? const Text(
                    "Cevaplanmadı olarak işaretle",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                : const Text(
                    "Cevaplandı olarak işaretle",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
      ),
    );
  }
}

class _voteWidgetBuilder extends StatefulWidget {
  QuestionModel question;

  _voteWidgetBuilder({
    super.key,
    required this.question,
  });

  @override
  State<_voteWidgetBuilder> createState() => _voteWidgetBuilderState();
}

class _voteWidgetBuilderState extends State<_voteWidgetBuilder> {
  @override
  Widget build(BuildContext context) {
    bool isQuestionVoted = Helpers.isQuestionVoted(
      context,
      questionModel: widget.question,
    );

    return InkWell(
      onTap: () {
        setState(
          () {
            isQuestionVoted
                ? widget.question.votes!.removeWhere((element) =>
                    element.userId == Helpers.getUserIdOrIpV4(context))
                : widget.question.votes!.add(
                    Vote(
                      eventId: widget.question.eventId,
                      questionId: widget.question.id,
                      userId: Helpers.getUserIdOrIpV4(context),
                      isAnonim: 0,
                      actionType: 1,
                    ),
                  );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isQuestionVoted ? Colors.green : null,
          border: Border.all(
            color: isQuestionVoted ? Colors.white : Colors.black,
            width: .5,
          ),
        ),
        child: Text(
          "+${widget.question.votes!.length}",
          style: TextStyle(
            fontSize: 11,
            color: isQuestionVoted ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
