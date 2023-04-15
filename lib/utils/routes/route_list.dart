import 'package:flutter/material.dart';
import 'package:question_board_mobile/screens/auth/login/login_screen.dart';
import 'package:question_board_mobile/screens/auth/register/register_screen.dart';
import 'package:question_board_mobile/screens/auth/splash/splash_screen.dart';
import 'package:question_board_mobile/screens/events/create/event_create_screen.dart';
import 'package:question_board_mobile/screens/events/detail/event_detail_screen.dart';
import 'package:question_board_mobile/screens/events/edit/event_edit_screen.dart';
import 'package:question_board_mobile/screens/events/list/events_list_screen.dart';
import 'package:question_board_mobile/screens/home/home_screen.dart';
import 'package:question_board_mobile/utils/routes/route_names.dart';

class RouteList {
  static Map<String, Widget Function(BuildContext)> screenRoutes = {
    // AUTH
    RouteNames.splash_screen: (context) => const SplashScreen(),
    RouteNames.login: (context) => const LoginScreen(),
    RouteNames.register: (context) => const RegisterScreen(),
    // AUTH

    RouteNames.home_screen: (context) => const HomeScreen(),

    // EVENT
    RouteNames.event_list: (context) => const EventListScreen(),
    RouteNames.event_detail: (context) => const EventDetailScreen(),
    RouteNames.event_create: (context) => const EventCreateScreen(),
    RouteNames.event_edit: (context) => const EventEditScreen(),
    // EVENT
  };
}
