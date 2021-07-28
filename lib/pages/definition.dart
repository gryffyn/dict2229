import 'package:dict2229/dict.dart';
import 'package:flutter/material.dart';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:dict2229/utils.dart';

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
    // TODO shared prefs
    // final prefs = await SharedPreferences.getInstance();
    // final address = prefs.getString('io.gryffyn.dict2229.server_url') ?? "";
    // final port = prefs.getInt('io.gryffyn.dict2229.port') ?? 0;
    var dict = Dict.newDict("neveris.one", 2628);
    var definition = await dict.define(parenthesize(text));
    setState(() {
      out = definition;
      input = text;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        FocusScope.of(context).requestFocus(_focusNode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8, top: 12, right: 8),
            child: TextField(
              autofocus: true,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'word to define',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (text) {
                getDef(text);
              },
            ),
          ),
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
                  Definition key = out.elementAt(index);
                  return RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(text: key.title + "\n", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: key.body + "\n\n"),
                        TextSpan(text: key.sourceName + "\n", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: DefaultTextStyle.of(context).style.fontSize!*0.7)),
                        TextSpan(text: key.sourceDesc + "\n", style: TextStyle(fontStyle: FontStyle.italic, fontSize: DefaultTextStyle.of(context).style.fontSize!*0.7)),
                      ],
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