import 'package:backdrop/backdrop.dart';
import 'package:dict2229/pages/about.dart';
import 'package:dict2229/pages/definition.dart';
import 'package:dict2229/pages/match.dart';
import 'package:dict2229/pages/settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'dict2229',
        darkTheme: ThemeData(
          canvasColor: Colors.black,
          brightness: Brightness.dark,
          primaryColor: Colors.pink,
          primarySwatch: Colors.pink,
          primaryTextTheme: TextTheme(
            bodyText1: TextStyle(
              color: Colors.white,
            ),
          ),
          //textTheme: GoogleFonts.latoTextTheme(
          //  Theme.of(context).textTheme,
          //),
        ),
        theme: ThemeData(
          primaryTextTheme: TextTheme(
            bodyText1: TextStyle(
              color: Colors.black,
            ),
          ),
          primaryColor: Colors.pink,
          primarySwatch: Colors.pink,
        ),
        themeMode: ThemeMode.system,
        home: Navigation(),
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
  final List<String> _subHeaders = ["Definition", "Match", "Settings", "About"];

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      frontLayerScrim: Colors.black54,
      appBar: BackdropAppBar(
        title: Text(_subHeaders[_currentIndex]),
      ),
      stickyFrontLayer: true,
      frontLayer: _pages[_currentIndex],
      backLayer: _createBackLayer(),
    );
  }

  Widget _createBackLayer() => BackdropNavigationBackLayer(
    items: [
      ListTile(
          title: Text(
            "Definition",
          )
      ),
      ListTile(
          title: Text(
            "Match",
          )
      ),
      ListTile(
          title: Text(
            "Settings",
          )
      ),
      ListTile(
          title: Text(
            "About",
          )
      ),
    ],
    onTap: (int position) => {setState(() => _currentIndex = position)},
  );
}