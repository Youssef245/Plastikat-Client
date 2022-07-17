import 'package:flutter/material.dart';
import 'package:plastikat_client/Login.dart';
import 'package:plastikat_client/Pages/HistoryPage.dart';
import 'package:plastikat_client/Pages/HomePage.dart';
import 'package:plastikat_client/Pages/PointsPage.dart';
import 'package:plastikat_client/Pages/ProfilePage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

class PlastikatDrawer extends StatelessWidget {


  Widget build(BuildContext context) {
    return MyPlastikatDrawer();
  }
}

class MyPlastikatDrawer extends StatelessWidget {
  final Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);

  MyPlastikatDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 16),
                  MenuItem(AppLocalizations.of(context)!.home,Icons.home,() => onClicked(context,0)),
                  const SizedBox(height: 16),
                  MenuItem(AppLocalizations.of(context)!.points,Icons.wallet_membership,() => onClicked(context,1)),
                  const SizedBox(height: 16),
                  MenuItem(AppLocalizations.of(context)!.th,Icons.history,() => onClicked(context,2)),
                  const SizedBox(height: 16),
                  MenuItem(AppLocalizations.of(context)!.p,Icons.person,() =>  onClicked(context,3)),
                  const SizedBox(height: 16),
                  MenuItem(AppLocalizations.of(context)!.logout,Icons.logout,() => onClicked(context,4)),
                ],
              ),
              //backgroundColor: Colors.red,
            )
          ],
        ));
  }

  Widget MenuItem(String text,IconData icon,VoidCallback onClicked) {
    return TextButton(
      onPressed: onClicked,
      child: ListTile(
        leading: Icon(icon,
          size: 24,
          color: plastikatGreen,),
        title: Text(text,
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontFamily: 'Poppins')),
      ),
    );
  }

  void onClicked (BuildContext context,int index){
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) => HomePage(),
        ),(route) => false);
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PointsPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HistoryPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Login(true),
        ));
        break;
    }
  }
}
