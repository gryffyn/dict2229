/*
 * Copyright (c) gryffyn 2021.
 * Licensed under the MIT license. See LICENSE file in the project root for details.
 */

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../dict.dart';
import '../utils.dart';

class MatchDialog extends StatelessWidget {
  const MatchDialog({Key? key, required this.match, required this.dict})
      : super(key: key);
  final String match;
  final String dict;

  Widget getDef(String match, String dict) {
    var box = Hive.box('prefs');
    var dc = Dict.newDict(box.get('addr'), int.tryParse(box.get('port'))!);
    return FutureBuilder<List<Definition>>(
        future: dc.define(parenthesize(match), dict),
        builder: (context, AsyncSnapshot<List<Definition>> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data![1].body);
          } else {
            return Container(
              height: 64,
              width: 64,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularProgressIndicator(),
                ],
              )
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.match),
      content: Container(
        width: double.minPositive,
        child: SingleChildScrollView(
          child: getDef(this.match, this.dict),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Return'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
