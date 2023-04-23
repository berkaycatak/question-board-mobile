// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/components/question/question_list_builder_widget.dart';
import 'package:question_board_mobile/components/loading_widget.dart';
import 'package:question_board_mobile/core/base/base_state.dart';
import 'package:question_board_mobile/core/base/base_view.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/models/QuestionModel.dart';
import 'package:question_board_mobile/style/colors.dart';
import 'package:question_board_mobile/style/text_styles.dart';
import 'package:question_board_mobile/utils/enums/screen_status.dart';
import 'package:question_board_mobile/utils/routes/route_names.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';
import 'package:question_board_mobile/view_models/event/event_view_model.dart';
import 'package:question_board_mobile/view_models/question/question_view_model.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends BaseState<EventDetailScreen> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController question_controller = TextEditingController();
  final TextEditingController name_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventViewModel>(context);

    return BaseView(
      floatingActionButton: _buildFloatingActionButton(),
      onModelReady: (context, args) async {
        args = args as EventModel;
        if (eventProvider.eventDetailModel == null) {
          await eventProvider.details(context, args);
        }
      },
      onDispose: () {
        eventProvider.eventDetailModel = null;
      },
      onWillPop: () {
        Navigator.of(context).pop(eventProvider.eventDetailModel);
        return Future.value(true);
      },
      onPageBuilder: (context, args) {
        return eventProvider.screenStatus == ScreenStatus.LOADING ||
                eventProvider.eventDetailModel == null
            ? SizedBox(
                height: deviceHeight / 1.4,
                child: loadingWidget(),
              )
            : const _EventDetailView();
      },
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.blackColor,
      onPressed: () async {
        showFlexibleBottomSheet(
          minHeight: 0,
          initHeight: 0.8,
          maxHeight: 1,
          context: context,
          builder: _buildBottomSheet,
          anchors: [0, .8, 1],
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    var authProvider = Provider.of<AuthViewModel>(context);
    var questionProvider = Provider.of<QuestionViewModel>(context);
    var eventProvider = Provider.of<EventViewModel>(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Material(
        child: ListView(controller: scrollController, children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "💬 Soru Ekle",
                    style: TextStyles.subTitle,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: question_controller,
                    validator: (val) =>
                        isNull(val!) ? "Lütfen sorunuzu girin." : null,
                    minLines: null,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '*Sorunuz',
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (authProvider.peopleModel == null)
                    TextFormField(
                      controller: name_controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'İsminiz',
                      ),
                    ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // This is what you need!
                      ),
                      onPressed: questionProvider.screenStatus ==
                              ScreenStatus.LOADING
                          ? null
                          : () async {
                              bool validate = formkey.currentState!.validate();

                              if (!validate) {
                                return null;
                              }

                              QuestionModel? questionModel =
                                  await questionProvider.create(
                                context,
                                question: question_controller.text,
                                name: name_controller.text,
                                eventModel: eventProvider.eventDetailModel!,
                              );

                              eventProvider.details(
                                context,
                                eventProvider.eventDetailModel!,
                              );
                              question_controller.text = "";
                              name_controller.text = "";

                              Navigator.of(context).pop();
                            },
                      child:
                          questionProvider.screenStatus == ScreenStatus.LOADING
                              ? loadingWidget()
                              : const Text("Soruyu Gönder"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
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
    var eventProvider = Provider.of<EventViewModel>(context);
    // null kontrolü koyulmalı.
    EventModel model = eventProvider.eventDetailModel!;
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
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    var eventProvider = Provider.of<EventViewModel>(context);

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
                backgroundColor: const Color.fromARGB(255, 23, 107, 232),
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
              child: const Text("Etkinliğe Katıl"),
            ),
          ),
        const SizedBox(height: 10),
        if (authProvider.peopleModel != null)
          if (model.createdUserId == authProvider.peopleModel!.id)
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // This is what you need!
                      ),
                      onPressed: () async {
                        Navigator.pushNamed(
                          context,
                          RouteNames.event_edit,
                          arguments: model,
                        );
                      },
                      child: const Text("Etkinliği Düzenle"),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // This is what you need!
                      ),
                      onPressed: () async {
                        var response = await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          title: "Emin misiniz?",
                          text:
                              'Etkinliği sildiğinizde bu işlemi geri alamazsınız.',
                          confirmBtnText: 'Sil',
                          cancelBtnText: 'Vazgeç',
                          confirmBtnColor: Colors.red,
                          onConfirmBtnTap: eventProvider.deleteScreenStatus ==
                                  ScreenStatus.LOADING
                              ? null
                              : () async {
                                  bool respose = await eventProvider.delete(
                                    context,
                                    eventModel: model,
                                  );
                                  if (respose) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteNames.home_screen,
                                      (route) => false,
                                    );
                                  }
                                },
                        );
                      },
                      child: const Text("Sil"),
                    ),
                  ),
                ),
              ],
            ),
      ],
    );
  }
}
