import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/db/db_helper.dart';
import '/services/notification_services.dart';
import '/ui/pages/home_page.dart';

import '/services/theme_services.dart';
import '/ui/theme.dart';

void main() async{
  //لازم السطر دا يتحط طالما خليت الداله async
  WidgetsFlutterBinding.ensureInitialized();
  NotifyHelper().initializeNotification();
  NotifyHelper().requestIOSPermissions();
  await DBHelper().initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      title: 'ToDo App',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
