import 'package:flutter/material.dart';
import 'package:question_board_mobile/components/event/question/question_widget.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';

Widget questionListBuilder(
    BuildContext context, List<QuestionModel>? questions) {
  if (questions == null) {
    return const Text("Henüz hiç soru eklenmemiş. Hemen sor!");
  } else if (questions.isEmpty) {
    return const Text("Henüz hiç soru eklenmemiş. Hemen sor!");
  } else {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        QuestionModel item = questions[index];
        return questionWidget(context, question: item);
      },
    );
  }
}
