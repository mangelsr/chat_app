import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

showCustomDialog(BuildContext context, String title, String subtitle) {
  if (Platform.isAndroid) {
    _showCustomAndroidDialog(context, title, subtitle);
  } else {
    _showCustomIosDialog(context, title, subtitle);
  }
}

_showCustomAndroidDialog(BuildContext context, String title, String subtitle) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: [
        MaterialButton(
            child: Text('OK'),
            elevation: 5,
            color: Colors.blue,
            onPressed: () => Navigator.pop(context))
      ],
    ),
  );
}

_showCustomIosDialog(BuildContext context, String title, String subtitle) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    ),
  );
}
