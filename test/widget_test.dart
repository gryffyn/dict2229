/*
 * Copyright (c) gryffyn 2021.
 * Licensed under the MIT license. See LICENSE file in the project root for details.
 */

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dict2229/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  testWidgets('Test homepage widgets', (WidgetTester tester) async {
    await tester.runAsync(() => Hive.initFlutter());
    await tester.runAsync(() => Hive.openBox('prefs'));
    await tester.pumpWidget(MyApp());
    expect(find.text('Define'), findsNWidgets(2));
    expect(find.byType(BackdropAppBar), findsOneWidget);

    await tester.tap(find.byType(BackdropToggleButton));
    await tester.pump();

    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
  });
}
