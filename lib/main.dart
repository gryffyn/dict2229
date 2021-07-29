/*
 * Copyright (c) gryffyn 2021.
 * Licensed under the MIT license. See LICENSE file in the project root for details.
 */

import 'package:backdrop/backdrop.dart';
import 'package:dict2229/config.dart';
import 'package:dict2229/pages/about.dart';
import 'package:dict2229/pages/definition.dart';
import 'package:dict2229/pages/match.dart';
import 'package:dict2229/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('prefs');
  setDefault(box);
  await appInfo.get();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var text2 = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
    return MaterialApp(
      title: 'dict2229',
      darkTheme: ThemeData(
        accentColor: Colors.pinkAccent,
        canvasColor: Colors.black,
        brightness: Brightness.dark,
        primaryColor: Colors.pink,
        primarySwatch: Colors.pink,
        primaryTextTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.white,
          ),
          bodyText2: text2,
        ),
      ),
      theme: ThemeData(
        accentColor: Colors.pinkAccent,
        primaryTextTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.black,
          ),
          bodyText2: text2,
        ),
        primaryColor: Colors.pink,
        primarySwatch: Colors.pink,
      ),
      themeMode: currentTheme.getCurrentTheme(),
      home: ValueListenableBuilder(
        valueListenable: Hive.box('prefs').listenable(),
        builder: (context, box, widget) => Navigation(),
      ),
    );
  }
}

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [PageDefinition(), PageMatch(), PageSettings(), PageAbout()];
  final List<String> _subHeaders = ["Define", "Match", "Settings", "About"];

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      animationCurve: Curves.fastLinearToSlowEaseIn,
      frontLayerScrim: Colors.black54,
      appBar: BackdropAppBar(
        titleSpacing: 10,
        brightness: Brightness.dark,
        title: Text(_subHeaders[_currentIndex]),
      ),
      stickyFrontLayer: true,
      frontLayer: _pages[_currentIndex],
      backLayer: _createBackLayer(context),
    );
  }

  List<ListTile> genItems(BuildContext context, Map<String, IconData> strings) {
    List<ListTile> items = [];
    strings.forEach((label, icon) {
      items.add(new ListTile(
        leading: Icon(icon,
          color: Theme.of(context).primaryTextTheme.bodyText2!.color,
        ),
        visualDensity: VisualDensity.compact,
        title: Text(label,
          style: Theme.of(context).primaryTextTheme.bodyText2,
        )
      ));
    });
    return items;
  }

  Widget _createBackLayer(BuildContext context) => BackdropNavigationBackLayer(
    items: genItems(context, {
      "Define"   : Icons.subject_rounded,
      "Match"    : Icons.swap_horiz_rounded,
      "Settings" : Icons.tune_rounded,
      "About"    : Icons.info_outline_rounded
    }),
    onTap: (int position) => {setState(() => _currentIndex = position)},
  );
}

setDefault(Box box) {
  if (box.get('addr') == null) {
    box.put('addr', 'neveris.one');
  }
  if (box.get('port') == null) {
    box.put('port', '2628');
  }
  if (box.get('dict') == null) {
    box.put('dict', '*');
  }
}