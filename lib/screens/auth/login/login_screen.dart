import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/components/loading_widget.dart';
import 'package:question_board_mobile/core/base/base_state.dart';
import 'package:question_board_mobile/core/base/base_view.dart';
import 'package:question_board_mobile/screens/home/home_screen.dart';
import 'package:question_board_mobile/style/text_styles.dart';
import 'package:question_board_mobile/utils/enums/screen_status.dart';
import 'package:question_board_mobile/utils/routes/route_names.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController email_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _authProvider = Provider.of<AuthViewModel>(context);

    return BaseView(
      onPageBuilder: (context, args) {
        return SizedBox(
          height: deviceHeight / 1.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Giriş Yap",
                textAlign: TextAlign.center,
                style: TextStyles.title,
              ),
              const SizedBox(height: 18),
              Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: email_controller,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                          !isEmail(val!) ? "E-Posta formatı geçersiz." : null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-Posta',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: password_controller,
                      obscureText: true,
                      validator: (val) =>
                          isNull(val!) ? "Lütfen parola girin." : null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Parola',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // This is what you need!
                  ),
                  onPressed: _authProvider.screenStatus == ScreenStatus.LOADING
                      ? null
                      : () async {
                          bool validate = formkey.currentState!.validate();
                          if (validate) {
                            bool statu = await _authProvider.login(
                              context,
                              email: email_controller.text,
                              password: password_controller.text,
                            );
                            if (statu) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteNames.home_screen,
                                (route) => false,
                              );
                            }
                          }
                        },
                  child: _authProvider.screenStatus == ScreenStatus.LOADING
                      ? loadingWidget()
                      : const Text("Giriş Yap"),
                ),
              ),
              const SizedBox(height: 18),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    RouteNames.register,
                  );
                },
                child: const Center(
                  child: Text(
                    "Henüz bir hesabınız yok mu?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
