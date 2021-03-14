import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class PrintError extends StatefulWidget {
  PrintError({Key key, this.responseCode}) : super(key: key);

  final int responseCode;

  @override
  PrintErrorMain createState() => PrintErrorMain();
}

/// This is the private State class that goes with MyStatefulWidget.
class PrintErrorMain extends State<PrintError> {
  Widget build(BuildContext context) {
    if (widget.responseCode == 204) {
      return AlertDialog(
        title: Text('Printing'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Successfully started to print.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else if (widget.responseCode == 408) {
      return AlertDialog(
        title: Text('Failed to start a print'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Printer is already printing something.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }
}
