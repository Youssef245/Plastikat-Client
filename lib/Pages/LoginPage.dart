import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plastikat_client/Pages/HistoryPage.dart';
import 'package:plastikat_client/Pages/PointsPage.dart';
import 'package:plastikat_client/Pages/PublishOffer.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'OngoingOffersPage.dart';

class LoginPage extends StatelessWidget {
  Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);

  final Future<void> Function() loginAction;
  final String loginError;

  LoginPage(this.loginAction, this.loginError, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 80),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Plastikat',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 60,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  'images/logo2.png',
                ),
                PlastikatButton("Login", (){
                  loginAction();
                }),
              ],
            ),
          )),
    );
  }
}
