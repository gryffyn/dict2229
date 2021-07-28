// TODO all of this. Consider dropdown box for strategy.

import 'package:dict2229/utils.dart';
import 'package:flutter/material.dart';

class ListDialogTap extends StatefulWidget {
  ListDialogTap({Key? key, required this.title, required this.text}) : super(key: key);
  final String title;
  final Map text;

  @override
  _ListDialogTap createState() => _ListDialogTap();
}

class _ListDialogTap extends State<ListDialogTap> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.widget.title),
      content: Container(
        width: double.minPositive,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: this.widget.text.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (BuildContext context, int index) {
            String key = this.widget.text.keys.elementAt(index);
            return ListTile(
              title: Text(key),
              subtitle: Text(stripParen(this.widget.text[key])),
            );
          },
        ),
      ),
    );
  }

}