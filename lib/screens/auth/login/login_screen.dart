import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/core/base/base_state.dart';
import 'package:question_board_mobile/core/base/base_view.dart';
import 'package:question_board_mobile/screens/home/home_screen.dart';
import 'package:question_board_mobile/style/text_styles.dart';
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
      onPageBuilder: (context) {
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
                  onPressed: () async {
                    bool validate = formkey.currentState!.validate();
                    if (validate) {
                      bool statu = await _authProvider.login(
                        context,
                        email: email_controller.text,
                        password: password_controller.text,
                      );
                      if (statu) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }
                    }
                  },
                  child: const Text("Giriş Yap"),
                ),
              ),
              const SizedBox(height: 18),
              const Center(
                child: Text(
                  "Henüz bir hesabınız yok mu?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
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
