// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/components/loading_widget.dart';
import 'package:question_board_mobile/core/base/base_view.dart';
import 'package:question_board_mobile/models/EventModel.dart';
import 'package:question_board_mobile/screens/events/detail/event_detail_screen.dart';
import 'package:question_board_mobile/style/text_styles.dart';
import 'package:question_board_mobile/utils/enums/screen_status.dart';
import 'package:question_board_mobile/view_models/event/event_view_model.dart';
import 'package:validators/validators.dart';

class EventCreateScreen extends StatefulWidget {
  const EventCreateScreen({super.key});

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  @override
  Widget build(BuildContext context) {
    var _eventProvider = Provider.of<EventViewModel>(context);

    return BaseView(
      onDispose: () {
        _eventProvider.eventCreateClearDispose();
      },
      onPageBuilder: (context, args) {
        return const _EventCreateView();
      },
    );
  }
}

class _EventCreateView extends StatefulWidget {
  const _EventCreateView({super.key});

  @override
  State<_EventCreateView> createState() => __EventCreateViewState();
}

class __EventCreateViewState extends State<_EventCreateView> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController name_controller = TextEditingController();
  final TextEditingController time_controller = TextEditingController();
  final TextEditingController description_controller = TextEditingController();
  final TextEditingController adress_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _eventProvider = Provider.of<EventViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "✍🏻 Etkinlik Panosu",
          style: TextStyles.subTitle,
        ),
        const SizedBox(height: 18),
        Text(
          "Etkinlik Oluştur",
          style: TextStyles.title,
        ),
        const SizedBox(height: 6),
        const Text(
          "Etkinlik oluşturup linki paylaşarak soru kabul etmeye bir form kadar uzaktasınız!",
        ),
        const SizedBox(height: 14),
        Form(
          key: formkey,
          child: Column(
            children: [
              TextFormField(
                controller: name_controller,
                validator: (val) =>
                    isNull(val!) ? "Lütfen etkinlik başlığı girin." : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '*Etkinlik Başlığı',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: time_controller,
                      validator: (val) => isNull(val!)
                          ? "Lütfen etkinlik saatini girin."
                          : null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '*Etkinlik Saati',
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async => _showDatePicker(),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(.4)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            height: 60,
                            child: Text(
                              _eventProvider.eventCreateSelectedDate != null
                                  ? _eventProvider.eventCreateSelectedDate
                                      .toString()
                                      .substring(0, 10)
                                  : "*Etkinlik Tarihi",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(.6),
                              ),
                            ),
                          ),
                        ),
                        if (_eventProvider
                            .eventCreateSelectedDateShowErrorMessage)
                          const Padding(
                            padding: EdgeInsets.only(top: 7.0, left: 10),
                            child: Text(
                              "Lütfen etkinlik tarihi seçin.",
                              style: TextStyle(
                                color: Color.fromARGB(255, 228, 47, 34),
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: description_controller,
                minLines: null,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Etkinlik Konusu',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: adress_controller,
                keyboardType: TextInputType.url,
                validator: (val) =>
                    !isURL(val!) ? "Lütfen link formatı girin." : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Etkinlik Adresi',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // This is what you need!
            ),
            onPressed: _eventProvider.screenStatus == ScreenStatus.LOADING
                ? null
                : () async {
                    EventModel? _eventModel = await _eventProvider.create(
                      context,
                      formkey,
                      title: name_controller.text,
                      adress: adress_controller.text,
                      description: description_controller.text,
                      time: time_controller.text,
                    );
                    if (_eventModel != null) {
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => EventDetailScreen(
                            eventModel: _eventModel,
                          ),
                        ),
                      );
                    }
                  },
            child: _eventProvider.screenStatus == ScreenStatus.LOADING
                ? loadingWidget()
                : const Text("Etkinlik Oluştur"),
          ),
        ),
      ],
    );
  }

  void _showDatePicker() async {
    var _eventProvider = Provider.of<EventViewModel>(context, listen: false);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), //get today's date
      firstDate: DateTime(
          2000), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2101),
    );
    _eventProvider.setCreateSelectedDate(pickedDate);
  }
}
