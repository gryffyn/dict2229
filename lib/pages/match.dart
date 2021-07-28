import 'package:dict2229/dialogs/listDialog.dart';
import 'package:dict2229/dict.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:dict2229/utils.dart';

class PageMatch extends StatefulWidget {
  PageMatch({Key? key}) : super(key: key);

  @override
  _PageMatch createState() => _PageMatch();
}

class _PageMatch extends State<PageMatch> {
  var out = "";
  var search = "";
  var strat = "";
  final FocusNode _focusNode = FocusNode();

  void getDef(String text) async {
    setState(() {
      search = text;
    });
    // TODO shared prefs
    // final prefs = await SharedPreferences.getInstance();
    // final address = prefs.getString('io.gryffyn.dict2229.server_url') ?? "";
    // final port = prefs.getInt('io.gryffyn.dict2229.port') ?? 0;
    var dict = Dict.newDict("neveris.one", 2628);
    var definition = await dict.match(parenthesize(text), strat);
    setState(() {
      out = definition;
    });
  }

  void setStrat(String text) async {
    setState(() {
      strat = text;
    });
  }

  void showList() async {
    var dict = Dict.newDict("neveris.one", 2628);
    var strats = await dict.getStrategies();
    showDialog(
        context: context,
        builder: (BuildContext context) => ListDialog(
              title: "Strategies",
              text: strats,
            ));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) =>FocusScope.of(context).requestFocus(_focusNode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8, top: 8, right: 8),
            child: TextField(
              autofocus: true,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'string to match',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (text) {
                getDef(text);
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 8, top: 8, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'stragegy to use',
                        border: OutlineInputBorder(),
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
                    icon: Icon(Icons.list_alt_rounded, color: Colors.pink),
                  )
                ],
              )),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(out, softWrap: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
