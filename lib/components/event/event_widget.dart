import 'package:flutter/material.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/screens/events/detail/event_detail_screen.dart';

Widget eventWidget(BuildContext context, EventModel event) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailScreen(
            eventModel: event,
          ),
        ),
      );
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          event.name ?? "Başlık eklenmemiş.",
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("⏰ ${event.time}"),
            Text("🗓 ${event.date}"),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(
                      eventModel: event,
                    ),
                  ),
                );
              },
              child: const Text("Etkinliğe Git"),
            ),
          ],
        ),
      ],
    ),
  );
}
