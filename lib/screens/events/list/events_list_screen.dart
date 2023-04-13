import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/components/event/event_list_builder_widget.dart';
import 'package:question_board_mobile/components/event/event_widget.dart';
import 'package:question_board_mobile/components/loading_widget.dart';
import 'package:question_board_mobile/core/base/base_state.dart';
import 'package:question_board_mobile/core/base/base_view.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/style/text_styles.dart';
import 'package:question_board_mobile/style/text_styles.dart';
import 'package:question_board_mobile/utils/enums/screen_status.dart';
import 'package:question_board_mobile/view_models/event/event_view_model.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends BaseState<EventListScreen> {
  @override
  Widget build(BuildContext context) {
    var _eventProvider = Provider.of<EventViewModel>(context);

    return BaseView(
      onModelReady: () async {
        _eventProvider.events(context);
      },
      onPageBuilder: (context) =>
          _eventProvider.screenStatus == ScreenStatus.LOADING
              ? loadingWidget()
              : const _EventListView(),
    );
  }
}

class _EventListView extends StatefulWidget {
  const _EventListView({
    super.key,
  });

  @override
  State<_EventListView> createState() => __EventListViewState();
}

class __EventListViewState extends BaseState<_EventListView> {
  @override
  Widget build(BuildContext context) {
    var _eventProvider = Provider.of<EventViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "👀 Etkinlikler",
          style: TextStyles.subTitle,
        ),
        const SizedBox(height: 14),
        eventBuilder(
          title: 'Yaklaşan Etkinlikler',
          events: _eventProvider.coming_events,
        ),
        const SizedBox(height: 14),
        eventBuilder(
          title: 'Geçmiş Etkinlikler',
          events: _eventProvider.past_events,
        ),
      ],
    );
  }

  Widget eventBuilder({required String title, List<EventModel>? events}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.title,
        ),
        const SizedBox(height: 14),
        eventListBuilder(context, events),
      ],
    );
  }
}
