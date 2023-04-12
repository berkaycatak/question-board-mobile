import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/core/base/base_state.dart';
import 'package:question_board_mobile/screens/auth/login/login_screen.dart';
import 'package:question_board_mobile/screens/auth/splash/splash_screen.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';

class BaseView<T> extends StatefulWidget {
  final Widget Function(BuildContext context)? onPageBuilder;
  final VoidCallback? onModelReady;
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
    if (widget.onModelReady != null) {
      widget.onModelReady!();
    }
    super.initState();
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
    var _authProvider = Provider.of<AuthViewModel>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: SizedBox(
            width: 140,
            child: Image.asset("assets/app/logos/logo.png"),
          ),
          actions: [
            if (_authProvider.peopleModel == null)
              IconButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.person),
              )
            else
              InkWell(
                onTap: () async {
                  bool status = await _authProvider.logout(context);
                  if (status) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const SplashScreen()),
                        (Route<dynamic> route) => false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: Text(
                      _authProvider.peopleModel!.name!,
                    ),
                  ),
                ),
              ),
          ],
          leading: Navigator.canPop(context) ? const BackButton() : null,
        ),
        drawer: Drawer(),
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
