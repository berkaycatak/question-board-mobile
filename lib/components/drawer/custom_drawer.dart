import 'package:flutter/material.dart';
import 'package:question_board_mobile/screens/events/list/events_list_screen.dart';
import 'package:question_board_mobile/screens/home/home_screen.dart';
import 'package:question_board_mobile/style/colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.greyColorBottomSheet,
              ),
              child: Stack(children: const [
                Positioned(
                  bottom: 8.0,
                  left: 4.0,
                  child: Text(
                    'Soru Tahtası',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ]),
            ),
            ListTile(
              leading: Icon(Icons.people_outline),
              title: const Text('Etkinlikler'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EventListScreen(),
                ));
              },
            ),
          ]),
    );
  }
}
