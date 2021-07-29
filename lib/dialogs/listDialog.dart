/*
 * Copyright (c) gryffyn 2021.
 * Licensed under the MIT license. See LICENSE file in the project root for details.
 */

import 'package:dict2229/utils.dart';
import 'package:flutter/material.dart';

class ListDialog extends StatelessWidget {
  const ListDialog({Key? key, required this.title, required this.text})
      : super(key: key);
  final String title;
  final Map text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.title),
      content: Container(
        width: double.minPositive,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: text.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (BuildContext context, int index) {
            String key = text.keys.elementAt(index);
            return ListTile(
              title: Text(key),
              subtitle: Text(stripParen(text[key])),
            );
          },
        ),
      ),
    );
  }
}
