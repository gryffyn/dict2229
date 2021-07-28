import 'package:flutter/material.dart';

class PageAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LicensePage(
      applicationName: 'dict2229',
      applicationVersion: '0.1.1',
      applicationLegalese: 'Copyright © gryffyn 2021',
    );
  }
}