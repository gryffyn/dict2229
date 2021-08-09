/*
 * Copyright (c) gryffyn 2021.
 * Licensed under the MIT license. See LICENSE file in the project root for details.
 */

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';

String parenthesize(String input) {
  var out = input;
  if (!input.startsWith("\"")) {
    out = "\"" + out;
  }
  if (!input.endsWith("\"")) {
    out += "\"";
  }
  return out;
}

String stripParen(String input) {
  return input.trim().substring(1,input.length-1);
}

class ThemeSetting with ChangeNotifier {
  static ThemeMode mode = ThemeMode.system;
  static Box box = Hive.box('prefs');

  ThemeSetting() {
    if (box.containsKey('theme')) {
      mode = stringToMode(box.get('theme'));
    } else {
      box.put('theme', 'system');
    }
  }

  ThemeMode getCurrentTheme() {
    return mode;
  }

  ThemeMode stringToMode(String mode) {
    switch (mode) {
      case 'dark': {
        return ThemeMode.dark;
      }
      case 'light': {
        return ThemeMode.light;
      }
      case 'system': {
        return ThemeMode.system;
      }
      default: {
        return ThemeMode.system;
      }
    }
  }

  String modeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark: {
        return 'dark';
      }
      case ThemeMode.light: {
        return 'light';
      }
      case ThemeMode.system: {
        return 'system';
      }
      default: {
        return 'system';
      }
    }
  }

  void setTheme(ThemeMode newMode) {
    mode = newMode;
    _saveTheme(newMode);
    notifyListeners();
  }

  void _saveTheme(ThemeMode newMode) {
    box.put('theme', modeToString(newMode));
  }

  void setSystemTheme() {
    mode = ThemeMode.system;
    _saveTheme(ThemeMode.system);
    notifyListeners();
  }

  void toggleTheme() {
    if (mode == ThemeMode.dark || mode == ThemeMode.system) {
      mode = ThemeMode.light;
      _saveTheme(ThemeMode.light);
      notifyListeners();
      return;
    }
    if (mode == ThemeMode.light || mode == ThemeMode.system) {
      mode = ThemeMode.dark;
      _saveTheme(ThemeMode.dark);
      notifyListeners();
      return;
    }
  }
}

class AppInfo {
  late String appName = "";
  late String packageName = "";
  late String version = "";
  late String buildNumber = "";

  get() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    this.appName = packageInfo.appName;
    this.packageName = packageInfo.packageName;
    this.version = packageInfo.version;
    this.buildNumber = packageInfo.buildNumber;
  }
}