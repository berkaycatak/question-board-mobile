// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/components/appbar/custom_appbar.dart';
import 'package:question_board_mobile/components/drawer/custom_drawer.dart';
import 'package:question_board_mobile/core/base/base_state.dart';
import 'package:question_board_mobile/screens/auth/login/login_screen.dart';
import 'package:question_board_mobile/screens/auth/splash/splash_screen.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';

class BaseView<T> extends StatefulWidget {
  final Widget Function(BuildContext context)? onPageBuilder;
  final Function? onModelReady;
  final VoidCallback? onDispose;

  BaseView({
    super.key,
    this.onModelReady,
    this.onPageBuilder,
    this.onDispose,
  });

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends BaseState<BaseView> {
  @override
  void initState() {
    asyncInit();
    super.initState();
  }

  void asyncInit() async {
    if (widget.onModelReady != null) {
      await widget.onModelReady!();
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
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: widget.onPageBuilder!(context),
            ),
          ],
        ),
      ),
    );
  }
}
