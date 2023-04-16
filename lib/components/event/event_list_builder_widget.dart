import 'package:flutter/material.dart';
import 'package:question_board_mobile/components/event/event_widget.dart';
import 'package:question_board_mobile/models/EventModel.dart';

Widget eventListBuilder(BuildContext context, List<EventModel>? events) {
  if (events == null) {
    return const Text("Henüz hiç etkinlik yok. Hemen oluştur!");
  } else if (events.isEmpty) {
    return const Text("Henüz hiç etkinlik yok. Hemen oluştur!");
  } else {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        EventModel item = events[index];
        return EventWidget(event: item);
      },
    );
  }
}
