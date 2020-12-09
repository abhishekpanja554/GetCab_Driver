import 'package:flutter/material.dart';

class AvailabilityButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final Color color;

  AvailabilityButton({@required this.buttonText, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color: color,
      textColor: Colors.white,
      child: Container(
        height: 50,
        width: 200,
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Brand-Bold',
            ),
          ),
        ),
      ),
    );
  }
}
