import 'package:dict2229/pages/definition.dart';
import 'package:dict2229/pages/match.dart';
import 'package:dict2229/pages/settings.dart';
// import 'package:dict2229/pages/settings.dart';
import 'package:dict2229/pages/settingsWIP.dart';
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
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                brightness: Brightness.dark,
                title: const Text('dict2229'),
              ),
              bottomNavigationBar: Builder(builder: (BuildContext context) {
                return TabBar(
                  labelColor: Theme.of(context).primaryTextTheme.bodyText1!.color,
                  indicatorColor: Colors.pink,
                  tabs: [
                    Tab(text: "Definition"),
                    Tab(text: "Match"),
                    Tab(text: "Settings"),
                  ],
                );
              }),
              body: TabBarView(
                children: [
                  PageDefinition(),
                  PageMatch(),
                  // TODO finish PageSettings
                  PageSettings(),
                  // PageSettingsWIP(),
                ],
              ),
            )
        ),
    );
  }
}
