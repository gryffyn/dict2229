/*
 * Copyright (c) gryffyn 2021.
 * Licensed under the MIT license. See LICENSE file in the project root for details.
 */

import 'package:dict2229/dict.dart';
import 'package:flutter/material.dart';
import 'package:dict2229/utils.dart';
import 'package:hive/hive.dart';

class PageDefinition extends StatefulWidget {
  PageDefinition({Key? key}) : super(key: key);

  @override
  _PageDefinition createState() => _PageDefinition();
}

class _PageDefinition extends State<PageDefinition> {
  final FocusNode _focusNode = FocusNode();
  late List<Definition> out = [];
  late String input = "";

  void getDef(String text) async {
    var box = Hive.box('prefs');
    var dc = Dict.newDict(box.get('addr'), int.tryParse(box.get('port'))!);
    var definition = await dc.define(parenthesize(text), box.get('dict'));
    setState(() {
      out = definition;
      input = text;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(_focusNode));
  }

  List<TextSpan> buildText(Definition key) {
    if (key.sourceName == "") {
      return <TextSpan>[
        TextSpan(
            text: key.title, style: TextStyle(fontWeight: FontWeight.bold)),
      ];
    }
    return <TextSpan>[
      TextSpan(
          text: key.title + "\n",
          style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: key.body + "\n\n"),
      TextSpan(
          text: key.sourceName + "\n",
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: DefaultTextStyle.of(context).style.fontSize! * 0.7)),
      TextSpan(
          text: key.sourceDesc + "\n",
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: DefaultTextStyle.of(context).style.fontSize! * 0.7)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 12, top: 16, right: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'word to define',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          input = text;
                        });
                      },
                      onSubmitted: (text) {
                        getDef(text);
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      getDef(input);
                    },
                    icon: Icon(Icons.send_rounded, color: Theme.of(context).primaryColor),
                  ),
                ],
              )),
          // TODO List dictionaries and allow choice
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: ListView.separated(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: out.length,
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  Definition key = out.elementAt(index);
                  return RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: buildText(key),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
