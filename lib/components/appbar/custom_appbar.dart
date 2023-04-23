import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_board_mobile/core/base/base_state.dart';
import 'package:question_board_mobile/screens/auth/login/login_screen.dart';
import 'package:question_board_mobile/screens/auth/splash/splash_screen.dart';
import 'package:question_board_mobile/utils/routes/route_names.dart';
import 'package:question_board_mobile/view_models/auth/auth_view_model.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends BaseState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    var _authProvider = Provider.of<AuthViewModel>(context);
    String? current_route_name = ModalRoute.of(context)?.settings.name;

    return AppBar(
      titleSpacing: 0,
      elevation: .5,
      centerTitle: false,
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      title: SizedBox(
        height: 25,
        child: Image.asset("assets/app/logos/logo.png"),
      ),
      actions: [
        if (current_route_name != RouteNames.login &&
            current_route_name != RouteNames.register)
          if (_authProvider.peopleModel == null)
            IconButton(
              onPressed: () async {
                Navigator.pushNamed(context, RouteNames.login);
              },
              icon: const Icon(Icons.person),
            )
          else
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                // PopupMenuItem 1
                PopupMenuItem(
                  value: 1,
                  // row with 2 children
                  child: Row(
                    children: const [
                      Icon(
                        Icons.logout,
                        size: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Çıkış Yap",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
                // PopupMenuItem 2
              ],
              offset: const Offset(0, 50),
              color: Colors.white,
              elevation: 1,
              // on selected we show the dialog box
              onSelected: (value) async {
                if (value == 1) {
                  bool status = await _authProvider.logout(context);
                  if (status) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouteNames.splash_screen, (route) => false);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _authProvider.peopleModel!.profilePhotoUrl!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ],
      leading: ModalRoute.of(context)?.settings.name != RouteNames.home_screen
          ? const BackButton()
          : null,
    );
  }
}
