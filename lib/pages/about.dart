/*
 * Copyright (c) gryffyn 2021.
 * Licensed under the MIT license. See LICENSE file in the project root for details.
 */

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PageAbout extends StatelessWidget {
  static const _url = "https://git.neveris.one/gryffyn/dict2229";
  void _launchURL() async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    var div = Divider(
      thickness: 2,
    );
    _PackageInfo info = new _PackageInfo();
    info.get();
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
                leading: Icon(Icons.info_outline_rounded),
                title: Text('App Info'),
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: info.appName,
                  applicationVersion: info.version + "+" + info.buildNumber,
                  applicationLegalese: 'Copyright © gryffyn 2021',
                ),
              ),
            ],
          )
      ),
    );
  }
}

class _PackageInfo {
  late String appName = "";
  late String packageName = "";
  late String version = "";
  late String buildNumber = "";

  get() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    this.appName = packageInfo.appName;
    this.packageName = packageInfo.packageName;
    this.version = packageInfo.version;
    this.buildNumber = packageInfo.buildNumber;
  }
}