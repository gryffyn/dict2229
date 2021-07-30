/*
 * Copyright (c) gryffyn 2021.
 * Licensed under the MIT license. See LICENSE file in the project root for details.
 */

import 'package:dict2229/config.dart';
import 'package:dict2229/dict.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../utils.dart';

class PageSettings extends StatelessWidget {
  void buildDialog(BuildContext context, String pref, Box box, String title) {
    String label = box.get(pref);
    late TextInputType inputType;
    if (pref == 'addr') {
      inputType = TextInputType.text;
    } else if (pref == 'port') {
      inputType = TextInputType.number;
    }

    var alert = SettingDialog(
      title: title,
      label: label,
      pref: pref,
      inputType: inputType,
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  resetAddr(Box box) {
    box.put('addr', 'dict.neveris.one');
  }

  resetPort(Box box) {
    box.put('port', '2628');
  }

  @override
  Widget build(BuildContext context) {
    var div = Divider(
      color: Colors.grey,
    );
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: Hive.box('prefs').listenable(keys: ['addr', 'port', 'theme']),
          builder: (context, Box box, widget) {
            return Center(
                child: ListView(
                  padding: EdgeInsets.only(left: 14, top: 12, right: 14),
                  children: [
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      leading: Container(
                        height: double.infinity,
                        child: Icon(Icons.storage),
                      ),
                      title: Text('Server Address'),
                      subtitle: Text(box.get('addr')),
                      onTap: () => buildDialog(context,
                        'addr', box, 'Server Address',
                      ),
                      onLongPress: () => resetAddr(box),
                    ),
                    div,
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      leading: Container(
                        height: double.infinity,
                        child: Icon(Icons.settings_ethernet_rounded),
                      ),
                      title: Text('Server Port'),
                      subtitle: Text(box.get('port')),
                      onTap: () => buildDialog(context,
                        'port', box, 'Server Port',
                      ),
                      onLongPress: () => resetPort(box),
                    ),
                    div,
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      leading: Container(
                        height: double.infinity,
                        child: Icon(Icons.wb_sunny_outlined),
                      ),
                      title: Text('Theme'),
                      subtitle: Text(box.get('theme')),
                      onTap: currentTheme.toggleTheme,
                      onLongPress: () => currentTheme.setSystemTheme(),
                    ),
                  ],
                )
            );
          },
        ),
    );
  }
}

class DDicts extends StatelessWidget {
  const DDicts({Key? key}) : super(key: key);

  Future<Map> getDicts() async {
    var box = Hive.box('prefs');
    var dc = Dict.newDict(box.get('addr'), int.tryParse(box.get('port'))!);
    var dicts = await dc.getDatabases();
    return dicts;
  }

  List<DropdownMenuItem<String>> createItems(Map data) {
    List<DropdownMenuItem<String>> items = [];
    for (var entry in data.keys) {
      items.add(new DropdownMenuItem(
          child: Text(
            entry,
            style: TextStyle(fontSize: 20),
          )
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
        future: getDicts(),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            return DropdownButton(
              items: createItems(snapshot.data!),
            );
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}

class SettingDialog extends StatefulWidget {
  const SettingDialog(
      {Key? key, required this.title, required this.label, required this.pref, required this.inputType})
      : super(key: key);
  final TextInputType inputType;
  final String title;
  final String label;
  final String pref;

  @override
  _SettingDialog createState() => _SettingDialog();
}

class _SettingDialog extends State<SettingDialog> {
  var input;
  final controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  saveState() {
    var box = Hive.box('prefs');
    box.put(this.widget.pref, controller.text);
    setState(() {
      input = controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: Text(this.widget.title),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            enableSuggestions: false,
            keyboardType: this.widget.inputType,
            decoration: InputDecoration(
                border: UnderlineInputBorder(), labelText: this.widget.label),
            controller: controller,
            onFieldSubmitted: (_) {
              saveState();
              Navigator.of(context).pop();
            },
            onEditingComplete: () {
              saveState();
            },
          ),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            saveState();
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
