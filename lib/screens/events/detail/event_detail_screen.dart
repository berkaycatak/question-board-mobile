import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/components/event/event_list_builder_widget.dart';
import 'package:question_board_mobile/components/event/question/question_list_builder_widget.dart';
import 'package:question_board_mobile/components/loading_widget.dart';
import 'package:question_board_mobile/core/base/base_state.dart';
import 'package:question_board_mobile/core/base/base_view.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/screens/events/edit/event_edit_screen.dart';
import 'package:question_board_mobile/style/colors.dart';
import 'package:question_board_mobile/style/text_styles.dart';
import 'package:question_board_mobile/utils/enums/screen_status.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';
import 'package:question_board_mobile/view_models/event/event_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

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
      onModelReady: (context, args) async {
        await _eventProvider.details(context, widget.eventModel);
      },
      onDispose: () {
        _eventProvider.eventDetailModel = null;
      },
      onPageBuilder: (context, args) =>
          _eventProvider.screenStatus == ScreenStatus.LOADING &&
                  _eventProvider.eventDetailModel == null
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
    // null kontrolü koyulmalı.
    EventModel model = _eventProvider.eventDetailModel!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        eventDetails(model),
        const Divider(),
        const SizedBox(height: 5),
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
    var _authProvider = Provider.of<AuthViewModel>(context, listen: false);

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
              height: 15,
              width: 15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  model.creatorUser!.profilePhotoPath ??
                      "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg",
                ),
              ),
            ),
            const SizedBox(width: 7),
            Text(model.creatorUser!.name!),
          ],
        ),
        const SizedBox(height: 4),
        Text("⏰ ${model.time!}"),
        const SizedBox(height: 4),
        Text("🗓 ${model.date!}"),
        const SizedBox(height: 10),
        if (isURL(model.adress) && !isNull(model.adress))
          SizedBox(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 23, 107, 232),
              ),
              onPressed: () async {
                try {
                  launchUrl(
                    Uri.parse(model.adress!),
                  );
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Etkinliğe Katıl"),
            ),
          ),
        const SizedBox(height: 10),
        if (model.createdUserId == _authProvider.peopleModel!.id)
          SizedBox(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // This is what you need!
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventEditScreen(eventModel: model),
                  ),
                );
              },
              child: Text("Etkinliği Düzenle"),
            ),
          ),
      ],
    );
  }
}
