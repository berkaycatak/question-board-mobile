import 'package:flutter/material.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/utils/routes/route_names.dart';

class EventWidget extends StatefulWidget {
  EventModel event;
  EventWidget({super.key, required this.event});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        dynamic _eventModel = await Navigator.pushNamed(
          context,
          RouteNames.event_detail,
          arguments: widget.event,
        );
        if (_eventModel != null) {
          setState(() {
            widget.event = _eventModel;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.event.name ?? "Başlık eklenmemiş.",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("⏰ ${widget.event.time}"),
              Text("🗓 ${widget.event.date}"),
              TextButton(
                onPressed: () async {
                  dynamic _eventModel = await Navigator.pushNamed(
                    context,
                    RouteNames.event_detail,
                    arguments: widget.event,
                  );
                  if (_eventModel != null) {
                    setState(() {
                      widget.event = _eventModel;
                    });
                  }
                },
                child: const Text("Etkinliğe Git"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
