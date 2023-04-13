import 'package:flutter/material.dart';

Widget loadingWidget() {
  return const Center(
    child: SizedBox(
      height: 17,
      width: 17,
      child: CircularProgressIndicator.adaptive(),
    ),
  );
}
