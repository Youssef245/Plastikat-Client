import 'package:flutter/material.dart';

class PlastikatButton extends StatelessWidget {
  final Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);
  final String buttonText;

  final VoidCallback onclicked;

  PlastikatButton(this.buttonText, this.onclicked);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onclicked,
      child: Text(
        buttonText,
        style:
            TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Poppins'),
      ),
      style: ElevatedButton.styleFrom(
          primary: plastikatGreen,
          minimumSize: Size(144, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          )),
    );
  }
}
