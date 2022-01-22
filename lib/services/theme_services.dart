import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices {

  final GetStorage _box = GetStorage();
  final _key = 'isDarkMode';


  // ?? is meaning if the value == null
  bool _loadThemeFromBox()=> _box.read<bool>(_key) ?? false;
  _saveThemeFromBox(bool isDarkMode)=> _box.write(_key, isDarkMode);

  ThemeMode get theme => _loadThemeFromBox()? ThemeMode.dark:ThemeMode.light;

  void switchTheme(){
    Get.changeThemeMode(_loadThemeFromBox()? ThemeMode.light:ThemeMode.dark);
    _saveThemeFromBox(!_loadThemeFromBox());
  }
}
