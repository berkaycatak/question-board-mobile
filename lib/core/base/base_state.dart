import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  double get deviceHeight => MediaQuery.of(context).size.height;
  double get deviceWidth => MediaQuery.of(context).size.height;
  // String? current_route_name  = ModalRoute.of(context)?.settings.name;

  // buraya sık kullanılan değerler gelecek.
  // Örn:
  // ThemeData get themeData => Theme.of(context);
}

/*  class OrnekWidget extends StatefulWidget {
  const OrnekWidget({super.key});
  @override
  State<OrnekWidget> createState() => _OrnekWidgetState();
}
class _OrnekWidgetState extends BaseState<OrnekWidget> { // buradaki state yerine BaseState geliyor.
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: themeData.canvasColor, // burada tekrar türetmeye gerek kalmadan themeData olarak kullanabiliyoruz.
    );
  }
}  */
