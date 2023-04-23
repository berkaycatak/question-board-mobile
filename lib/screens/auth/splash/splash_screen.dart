import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/core/base/base_state.dart';
import 'package:question_board_mobile/screens/home/home_screen.dart';
import 'package:question_board_mobile/utils/routes/route_names.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen> {
  void tryAction(BuildContext context) async {
    await context.read<AuthViewModel>().splash(context).then(
      (value) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.home_screen,
          (route) => false,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    tryAction(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Image.asset("assets/app/logos/logo.png"),
        ),
      ),
    );
  }
}
