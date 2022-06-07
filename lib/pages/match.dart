/*
 * Copyright (c) gryffyn 2021.
 * Licensed under the MIT license. See LICENSE file in the project root for details.
 */

import 'package:dict2229/dialogs/listDialog.dart';
import 'package:dict2229/dialogs/matchDialog.dart';
import 'package:dict2229/dict.dart';
import 'package:flutter/material.dart';
import 'package:dict2229/utils.dart';
import 'package:hive/hive.dart';

class PageMatch extends StatefulWidget {
  PageMatch({Key? key}) : super(key: key);

  @override
  _PageMatch createState() => _PageMatch();
}

class _PageMatch extends State<PageMatch> {
  late List<Match> out = [];
  var search = "";
  var strat = "";
  final FocusNode _focusNode = FocusNode();

  void getDef(String text) async {
    var box = Hive.box('prefs');
    var dict = Dict.newDict(box.get('addr'), int.tryParse(box.get('port'))!);
    var definition = await dict.match(parenthesize(text), box.get('strat'), box.get('dict'));
    setState(() {
      search = text;
      out = definition;
    });
  }

  void setSearch(String text) {
    setState(() {
      search = text;
    });
  }

  void setStrat(String text) {
    var box = Hive.box('prefs');
    box.put('strat', text);
    setState(() {
      strat = text;
    });
  }

  String getStrat() {
    var box = Hive.box('prefs');
    var text = box.get('strat');
    setState(() {
      strat = text;
    });
    return text;
  }

  void showList() async {
    var box = Hive.box('prefs');
    var dict = Dict.newDict(box.get('addr'), int.tryParse(box.get('port'))!);
    var strats = await dict.getStrategies();
    showDialog(
      context: context,
      builder: (BuildContext context) => ListDialog(
            title: "Strategies",
            text: strats,
      )).then((value) => setStrat(value));
    _focusNode.requestFocus();
  }

  defineMatch(String match, String dict) {
    showDialog(context: context,
        builder: (BuildContext context) => MatchDialog(
          match: match,
          dict: dict,
    ));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>FocusScope.of(context).requestFocus(_focusNode));
  }

  List<TextSpan> buildText(Match key) {
    if (key.matchName == "") {
      return <TextSpan>[
        TextSpan(text: key.sourceName, style: TextStyle(fontWeight: FontWeight.bold)),
      ];
    }
    return <TextSpan>[
      TextSpan(text: key.matchName + "\n"),
      TextSpan(text: key.sourceName + "\n", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: DefaultTextStyle.of(context).style.fontSize!*0.7)),
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
                      hintText: 'string to match',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (text) {
                      setSearch(text);
                    },
                    onSubmitted: (text) {
                      getDef(text);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (search != "") {
                      getDef(search);
                    }
                  },
                  icon: Icon(Icons.send_rounded, color: Theme.of(context).primaryColor),
                ),
              ],
            )
          ),
          Padding(
              padding: EdgeInsets.only(left: 12, top: 8, right: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: getStrat(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (text) {
                        setStrat(text);
                      },
                      onSubmitted: (text) {
                        if (search != "") {
                          getDef(search);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: showList,
                    icon: Icon(Icons.list_alt_rounded, color: Theme.of(context).primaryColor),
                  )
                ],
              )),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: ListView.separated(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: out.length,
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  Match key = out.elementAt(index);
                  return InkWell(
                    onTap: () {
                      defineMatch(key.matchName, key.sourceName);
                    },
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: buildText(key),
                      ),
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
