import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plastikat_client/Pages/HistoryPage.dart';
import 'package:plastikat_client/Pages/PointsPage.dart';
import 'package:plastikat_client/Pages/PublishOffer.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'OngoingOffersPage.dart';
import 'package:plastikat_client/globals.dart' as globals;

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
      home: Scaffold(
          drawer: PlastikatDrawer(),
          appBar: PlastikatBar(),
          body: isLoaded ? Container(
            padding: const EdgeInsets.symmetric(vertical: 80),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Welcome, ${name!.split(" ")[0]}',
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
                  PlastikatButton("Make Offer", (){
                        Navigator.of(context);
                        Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PublishOffer()));}
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PlastikatButton("View Points",  (){
                        Navigator.of(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PointsPage()));}
                      ),
                      PlastikatButton("Ongoing Offers", (){
                        Navigator.of(context);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OngoingOffersPage()));}
                      )
                    ],
                  ),
                ],
              ),
            ),
          ): const CircularProgressIndicator()),
    );
  }
}
