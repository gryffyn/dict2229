import 'package:flutter/material.dart';

class PageSettingsWIP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Theme.of(context).primaryColor,
              size: 192,
            ),
            Text(
              'WIP',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 96,
              ),
            ),
          ],
        ),
      )
    );
  }
}