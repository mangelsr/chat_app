import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String title;

  const Logo({
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 40),
        width: 170,
        child: Column(
          children: [
            Image(image: AssetImage('assets/tag-logo.png')),
            SizedBox(height: 20),
            Text(this.title, style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
