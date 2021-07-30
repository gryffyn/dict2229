/*
 * Copyright (c) gryffyn 2021.
 * Licensed under the MIT license. See LICENSE file in the project root for details.
 */

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dict2229/config.dart';

class PageAbout extends StatelessWidget {
  static const _url = "https://git.neveris.one/gryffyn/dict2229";
  void _launchURL() async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    var div = Divider(
      thickness: 2,
    );
    return Scaffold(
      body: Center(
          child: ListView(
            padding: EdgeInsets.only(left: 14, top: 12, right: 14),
            children: [
              ListTile(
                visualDensity: VisualDensity.compact,
                leading: FaIcon(FontAwesomeIcons.codeBranch),
                title: Text('Source Code'),
                onTap: () => _launchURL(),
              ),
              div,
              ListTile(
                visualDensity: VisualDensity.compact,
                leading: Icon(Icons.copyright_rounded),
                title: Text('Licenses'),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: appInfo.appName,
                  applicationVersion: appInfo.version + "+" + appInfo.buildNumber,
                  applicationLegalese: 'Copyright © gryffyn 2021\nImages are copyright CC BY-NC-SA 4.0.',
                ),
              ),
              div,
              Container(
                padding: EdgeInsets.only(left: 14, top: 12, right: 14),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(text: appInfo.appName + "\n\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      TextSpan(text: appInfo.version + "+" + appInfo.buildNumber + "\n", style: TextStyle(fontSize: 16)),
                      TextSpan(text: "gryffyn", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}