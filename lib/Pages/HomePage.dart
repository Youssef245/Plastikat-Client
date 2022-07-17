import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plastikat_client/Pages/HistoryPage.dart';
import 'package:plastikat_client/Pages/PointsPage.dart';
import 'package:plastikat_client/Pages/PublishOffer.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'OngoingOffersPage.dart';
import 'package:plastikat_client/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

class HomePage extends StatefulWidget {

  HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);

  String? name;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData () async
  {
    name = await globals.user.read(key: "name");
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: isLoaded? MyHomePage(name!) : const CircularProgressIndicator() ,
    );
  }
}

class MyHomePage extends StatelessWidget{
  String name;
  MyHomePage(this.name);

  Widget build(BuildContext context) {
    return Scaffold(
        drawer: PlastikatDrawer(),
        appBar: PlastikatBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 80),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.welcome} ${name!.split(" ")[0]}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  'images/logo1.png',
                ),
                PlastikatButton(AppLocalizations.of(context)!.making_Offer, (){
                  Navigator.of(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PublishOffer()));}
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PlastikatButton(AppLocalizations.of(context)!.view_Points,  (){
                      Navigator.of(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PointsPage()));}
                    ),
                    PlastikatButton(AppLocalizations.of(context)!.ongoing_Offers, (){
                      Navigator.of(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OngoingOffersPage()));}
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

}
