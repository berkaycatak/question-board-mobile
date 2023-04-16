import 'package:flutter/material.dart';
import 'package:question_board_mobile/helpers/helpers.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';
import 'package:question_board_mobile/models/VoteModel.dart';

class QuestionVoteButtonWidget extends StatefulWidget {
  QuestionModel question;

  QuestionVoteButtonWidget({
    super.key,
    required this.question,
  });

  @override
  State<QuestionVoteButtonWidget> createState() =>
      QuestionVoteButtonWidgetState();
}

class QuestionVoteButtonWidgetState extends State<QuestionVoteButtonWidget> {
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
