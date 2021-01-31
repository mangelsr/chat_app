import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String text;
  final Function callback;

  const MainButton({
    @required this.text,
    @required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: this.callback,
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      child: Container(
        width: double.infinity,
        child: Center(
          child: Text(
            this.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
