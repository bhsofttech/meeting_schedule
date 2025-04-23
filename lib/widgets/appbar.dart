
import 'package:flutter/material.dart';
import 'package:meeting_schedule/const/const_color.dart';

AppBar buildAppBar({required String title, bool showAction = false}) {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    elevation: 0.0,
    centerTitle: true,
    backgroundColor: ConstColor.appBarBG,
    title: Text(
      title,
      style: const TextStyle(
        color: Color(0xff00F6DA),
        fontFamily: "Poppins",
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
