import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/components/loading_widget.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';
import 'package:question_board_mobile/view_models/question/question_view_model.dart';

class QuestionIsAnsweredButtonWidget extends StatefulWidget {
  QuestionModel question;
  QuestionIsAnsweredButtonWidget({
    super.key,
    required this.question,
  });

  @override
  State<QuestionIsAnsweredButtonWidget> createState() =>
      QuestionIsAnsweredButtonWidgetState();
}

class QuestionIsAnsweredButtonWidgetState
    extends State<QuestionIsAnsweredButtonWidget> {
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
