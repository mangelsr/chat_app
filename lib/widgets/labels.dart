import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String question;
  final String linkText;
  final String routeTo;

  const Labels({
    @required this.routeTo,
    @required this.question,
    @required this.linkText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Text(
              this.question,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed(this.routeTo),
              child: Text(
                this.linkText,
                style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
