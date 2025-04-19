import 'package:doc_scanner/database_helper.dart';
import 'package:doc_scanner/home_view.dart';
import 'package:doc_scanner/meeting_controller.dart';
import 'package:doc_scanner/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MeetingController());

  await DatabaseHelper().initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController _themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Meeting Scheduler',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeController.themeMode,
      home: HomeView(),
    );
  }
}

