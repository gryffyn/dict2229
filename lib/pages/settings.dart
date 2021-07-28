import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:application_icon/application_icon.dart';

class PageSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SettingsList(
            sections: [
              SettingsSection(
                tiles: [
                  SettingsTile(
                    title: 'Server Address',
                    subtitle: 'dict.org',
                    leading: Icon(Icons.storage),
                    onPressed: (BuildContext context) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                          Dialog(
                            title: 'Server address',
                            label: 'Server address',
                            pref: 'io.gryffyn.dict2229.server_url',
                          ),
                      );
                    },
                  ),
                  SettingsTile(
                    title: 'Server Port',
                    subtitle: '2628',
                    leading: Icon(Icons.storage),
                    onPressed: (BuildContext context) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                          Dialog(
                            title: 'Server port',
                            label: 'Server port',
                            pref: 'io.gryffyn.dict2229.port',
                          ),
                      );
                    },
                  ),
                  SettingsTile(
                    title: 'About',
                    leading: Icon(Icons.info_outline_rounded),
                    onPressed: (BuildContext context) {
                      showAboutDialog(context: context,
                        applicationName: 'dict2229',
                        applicationVersion: '0.1.1',
                        applicationLegalese: 'Copyright © gryffyn 2021',
                      );
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class Dialog extends StatefulWidget {
  const Dialog({Key? key, required this.title, required this.label, required this.pref}) : super(key: key);
  final String title;
  final String label;
  final String pref;

  @override
  _Dialog createState() => _Dialog();
}

class _Dialog extends State<Dialog> {
  var input;
  final controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  void saveState() async {
    final prefs = await SharedPreferences.getInstance();
    var inp;
    try {
      inp = int.parse(controller.text);
    }
    on FormatException {
      inp = controller.text;
    }
    prefs.setString(this.widget.pref, inp);
    setState(() {
      input = controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog (
      title: Text(this.widget.title),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                border: UnderlineInputBorder(), labelText: this.widget.label),
            controller: controller,
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            saveState();
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

Widget dialogAddress(BuildContext context) {
  String address;
  return new AlertDialog (
    title: const Text('Popup example'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
              border: UnderlineInputBorder(), labelText: 'Server address'),
        ),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme
            .of(context)
            .primaryColor,
        child: const Text('Save'),
      ),
    ],
  );
}