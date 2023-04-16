// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/components/loading_widget.dart';
import 'package:question_board_mobile/core/base/base_state.dart';
import 'package:question_board_mobile/core/base/base_view.dart';
import 'package:question_board_mobile/screens/home/home_screen.dart';
import 'package:question_board_mobile/services/request_services.dart';
import 'package:question_board_mobile/style/text_styles.dart';
import 'package:question_board_mobile/utils/enums/screen_status.dart';
import 'package:question_board_mobile/utils/routes/route_names.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';
import 'package:validators/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends BaseState<RegisterScreen> {
  final TextEditingController name_controller = TextEditingController();
  final TextEditingController email_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  final TextEditingController password_confirmation_controller =
      TextEditingController();

  final formkey = GlobalKey<FormState>();

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
                "Kayıt Ol",
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
                      controller: name_controller,
                      validator: (val) =>
                          isNull(val!) ? "Lütfen isim ve soyisim girin." : null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'İsim, Soyisim',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: email_controller,
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
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: password_confirmation_controller,
                      obscureText: true,
                      validator: (val) =>
                          isNull(val!) ? 'Lütfen parola girin.' : null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Parola Onay',
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
                            bool statu = await _authProvider.register(
                              context,
                              email: email_controller.text,
                              name: name_controller.text,
                              password: password_controller.text,
                              passwordConfirmation:
                                  password_confirmation_controller.text,
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
                      : const Text("Kayıt Ol"),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      RouteNames.login,
                    );
                  },
                  child: const Text(
                    "Zaten bir hesabınız var mı?",
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
