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
      /*
      darkTheme: ThemeData(
        accentColor: Colors.pinkAccent,
        canvasColor: createMaterialColor(Color(0xFF1d1e20)),
        brightness: Brightness.dark,
        primaryColor: Colors.pink,
        primarySwatch: Colors.pink,
        primaryTextTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.white,
          ),
          bodyText2: text2,
        ),
      ),  */
      darkTheme: F5Theme.theme,
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
      backgroundColor: Theme.of(context).backgroundColor,
      animationCurve: Curves.fastLinearToSlowEaseIn,
      frontLayerScrim: Colors.black54,
      appBar: BackdropAppBar(
        leading: BackdropToggleButton(color: Theme.of(context).primaryTextTheme.bodyText2!.color!),
        iconTheme: IconThemeData(color: Theme.of(context).primaryTextTheme.bodyText2!.color),
        backgroundColor: Theme.of(context).primaryColor,
        titleSpacing: 10,
        brightness: Brightness.dark,
        textTheme: Theme.of(context).primaryTextTheme,
        title: Text(_subHeaders[_currentIndex], style: TextStyle(color: Theme.of(context).primaryTextTheme.bodyText2!.color)),
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
  if (!box.containsKey('addr')) {
    box.put('addr', 'dict.neveris.one');
  }
  if (!box.containsKey('port')) {
    box.put('port', '2628');
  }
  if (!box.containsKey('dict')) {
    box.put('dict', '*');
  }
  if (!box.containsKey('strat')) {
    box.put('strat', '.');
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class F5Theme {
  static var theme = ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFFf5a9c9),
        foregroundColor: Color(0xFF1d1e20)
    ),
    dividerColor: Color(0xFF454547),
    canvasColor: Color(0xFF1d1e20),
    brightness: Brightness.dark,
    primaryColor: Color(0xFFf5a9c9),
    primaryTextTheme: TextTheme(
      bodyText1: TextStyle(
        color: Color(0xFFdadadb),
      ),
      bodyText2: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1d1e20),
      ),
      headline6: TextStyle(
        color: Color(0xFF1d1e20)
      )
    ),
    colorScheme: ColorScheme.dark(
      background: const Color(0xFF1d1e20),
      onBackground: const Color(0xFF454547),
      primary: const Color(0xFFf5a9c9),
      onPrimary: const Color(0xFFdadadb),
      primaryVariant: const Color(0xFFffffff),
      brightness: Brightness.dark,
    )
  );

}