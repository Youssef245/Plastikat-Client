import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plastikat_client/Pages/PartnersPage.dart';
import 'package:plastikat_client/entities/client.dart';
import 'package:plastikat_client/services/client_service.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plastikat_client/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

class PointsPage extends StatelessWidget {


  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home:MyPointsPage()
    );
  }
}



class MyPointsPage extends StatefulWidget {

  MyPointsPage();

  @override
  State<MyPointsPage> createState() => _MyPointsPageState();
}

class _MyPointsPageState extends State<MyPointsPage> {
  Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);

  int? points;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData () async {
    final ClientService service = ClientService(await globals.secureStorage.read(key: "access_token"));
    String? id = await globals.user.read(key: "id");
    final Client client = await service.getClientInformation(id!);
    points = client.points;
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: PlastikatDrawer(),
        appBar: PlastikatBar(),
        body: Center(child : isLoaded ? Column(
          children: [
            const SizedBox(height: 40),
            pointWidget(points!.toString()),
            const SizedBox(height: 40),
            Container(child: Text(
              AppLocalizations.of(context)!.quote,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w100),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.only(left: 20,right: 20),),
            const SizedBox(height: 40),
            PlastikatButton( AppLocalizations.of(context)!.view_Button, (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PartnersPage(points!)));}),
          ],
        ): const CircularProgressIndicator()),
      );
  }

  Widget pointWidget(String value) {
    return Container(
      child: Card(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.ur_Points,
              style: TextStyle(
                  color: plastikatGreen,
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Container(
              width: 290,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(width: 5,
                color: plastikatGreen),
                shape: BoxShape.circle,
                color: Color.fromRGBO(249, 249, 249, 100),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    value,
                    style: TextStyle(
                        color: plastikatGreen,
                        fontSize: 70,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.of(context)!.points,
                    style: TextStyle(
                        color: plastikatGreen,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            )
          ],
        ),
        color: Color.fromRGBO(255, 255, 255, 100),
        elevation: 3,
      ),
      width: 310,
      height: 313,
    );
  }
}
