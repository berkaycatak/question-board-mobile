import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/core/base/base_state.dart';
import 'package:question_board_mobile/core/base/base_view.dart';
import 'package:question_board_mobile/screens/auth/login/login_screen.dart';
import 'package:question_board_mobile/screens/auth/register/register_screen.dart';
import 'package:question_board_mobile/style/text_styles.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      onPageBuilder: (context) {
        return const _HomeWidget();
      },
    );
  }
}

class _HomeWidget extends StatefulWidget {
  const _HomeWidget({
    super.key,
  });

  @override
  State<_HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends BaseState<_HomeWidget> {
  @override
  Widget build(BuildContext context) {
    var _authProvider = Provider.of<AuthViewModel>(context);

    return SizedBox(
      height: deviceHeight / 1.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Soru Tahtası",
            textAlign: TextAlign.center,
            style: TextStyles.title,
          ),
          Text(
            "Linkini paylaş ve soruları gör!",
            textAlign: TextAlign.center,
            style: TextStyles.subTitle,
          ),
          const SizedBox(height: 14),
          const Text(
            "Soru Tahtası kullanarak etkinlik oluştur, linkini paylaş, ister anonim ister isim soyisim ile soruları kabul et!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 14),
          if (_authProvider.peopleModel == null) const _AuthButtons()
        ],
      ),
    );
  }
}

class _AuthButtons extends StatefulWidget {
  const _AuthButtons({
    super.key,
  });

  @override
  State<_AuthButtons> createState() => _AuthButtonsState();
}

class _AuthButtonsState extends BaseState<_AuthButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, // This is what you need!
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text("Giriş Yap"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // This is what you need!
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text("Kayıt Ol"),
            ),
          )
        ],
      ),
    );
  }
}
