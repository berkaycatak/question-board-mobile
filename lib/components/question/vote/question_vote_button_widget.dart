import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/components/loading_widget.dart';
import 'package:question_board_mobile/helpers/helpers.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';
import 'package:question_board_mobile/models/VoteModel.dart';
import 'package:question_board_mobile/view_models/question/question_view_model.dart';

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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var questionProvider = Provider.of<QuestionViewModel>(context);

    bool isQuestionVoted = Helpers.isQuestionVoted(
      context,
      questionModel: widget.question,
    );

    void vote() async {
      // yükleniyor işlemi provider üzerinden yönetildiğinde tüm sorularda
      // yükleniyor ikonu çıktığı için bu yöntemle halledildi.

      setState(() {
        isLoading = true;
      });

      Vote? _vote = await questionProvider.vote(
        context,
        questionModel: widget.question,
      );

      setState(() {
        isLoading = false;
      });

      setState(() {
        isQuestionVoted
            ? widget.question.votes!.removeWhere(
                (element) => element.userId == Helpers.getUserIdOrIpV4(context))
            : _vote != null
                ? widget.question.votes!.add(_vote)
                : null;
      });
    }

    return InkWell(
      onTap: () => vote(),
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
        child: isLoading
            ? SizedBox(height: 13, width: 13, child: loadingWidget())
            : Text(
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
