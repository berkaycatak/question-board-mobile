import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/components/event/event_list_builder_widget.dart';
import 'package:question_board_mobile/components/event/question/question_list_builder_widget.dart';
import 'package:question_board_mobile/components/loading_widget.dart';
import 'package:question_board_mobile/core/base/base_state.dart';
import 'package:question_board_mobile/core/base/base_view.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/style/text_styles.dart';
import 'package:question_board_mobile/utils/enums/screen_status.dart';
import 'package:question_board_mobile/view_models/event/event_view_model.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel eventModel;
  const EventDetailScreen({super.key, required this.eventModel});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends BaseState<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var _eventProvider = Provider.of<EventViewModel>(context);

    return BaseView(
      onModelReady: () async {
        _eventProvider.details(context, widget.eventModel);
      },
      onPageBuilder: (context) =>
          _eventProvider.screenStatus == ScreenStatus.LOADING
              ? loadingWidget()
              : const _EventDetailView(),
    );
  }
}

class _EventDetailView extends StatefulWidget {
  const _EventDetailView({
    super.key,
  });

  @override
  State<_EventDetailView> createState() => __EventDetailViewState();
}

class __EventDetailViewState extends BaseState<_EventDetailView> {
  @override
  Widget build(BuildContext context) {
    var _eventProvider = Provider.of<EventViewModel>(context);
    EventModel model = _eventProvider.eventDetailModel!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        eventDetails(model),
        const Divider(),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "🤔 Sorular",
              style: TextStyles.subTitle,
            ),
/*             Icon(
              Icons.filter_alt,
              size: 20,
            ),
 */
          ],
        ),
        questionListBuilder(context, model.questions),
      ],
    );
  }

  Widget eventDetails(EventModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          model.name ?? "Başlık eklenmemiş.",
          style: TextStyles.title,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: Image.network(
                model.creatorUser!.profilePhotoPath!,
              ),
            ),
            Text(model.creatorUser!.name!),
          ],
        ),
        const SizedBox(height: 4),
        Text("⏰ ${model.time!}"),
        const SizedBox(height: 4),
        Text("🗓 ${model.date!}"),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {},
          child: const Text(
            "Etkinliğe Katıl",
            style: TextStyle(
              color: Colors.blueGrey,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
