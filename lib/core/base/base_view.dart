// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:question_board_mobile/components/appbar/custom_appbar.dart';
import 'package:question_board_mobile/components/drawer/custom_drawer.dart';
import 'package:question_board_mobile/core/base/base_state.dart';

class BaseView<T> extends StatefulWidget {
  final Widget Function(BuildContext context, dynamic args)? onPageBuilder;
  final Function(BuildContext context, dynamic args)? onModelReady;
  final VoidCallback? onDispose;
  final FloatingActionButton? floatingActionButton;
  const BaseView({
    Key? key,
    this.onPageBuilder,
    this.onModelReady,
    this.onDispose,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends BaseState<BaseView> {
  dynamic args;
  bool openPage = false;

  @override
  void initState() {
    asyncInit();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments;
    if (widget.onModelReady != null) {
      widget.onModelReady!(context, args);
    }
  }

  void asyncInit() async {
    if (widget.onModelReady != null) {
      await widget.onModelReady!(context, args);
    }
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose!();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        drawer: const CustomDrawer(),
        floatingActionButton: widget.floatingActionButton,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: widget.onPageBuilder!(context, args),
            ),
          ],
        ),
      ),
    );
  }
}
