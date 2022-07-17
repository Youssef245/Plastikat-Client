import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plastikat_client/entities/offer.dart';
import 'package:plastikat_client/services/client_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/OfferInfo.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'package:plastikat_client/globals.dart' as globals;

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);
  List<ClientOffer> history = [];
  bool isLoaded=false;
  int? i;


  @override
  void initState() {
    super.initState();
    getOffers();
  }

   getOffers() async {
     final ClientService service = new ClientService(await globals.secureStorage.read(key: "access_token"));
     String? id = await globals.user.read(key: "id");
     List<ClientOffer> offers = await service.getClientOffers(id!);
     print(offers.length);
     for (ClientOffer offer in offers)
     {
         if(offer.status=="COMPLETED"||offer.status=="CANCELED") {
           history.add(offer);
         }
     }
     setState(() {
       isLoaded = true;
     });
  }

  @override
  Widget build(BuildContext context) {
    i=0;
    return MaterialApp(
      home: Scaffold(
          drawer: PlastikatDrawer(),
          appBar: PlastikatBar(),
          body: isLoaded? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
            children: [
                ...history.map((offer) {
                  i = i!+1;
                  return Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Offer No. ${i}",
                        style: TextStyle(
                          color: plastikatGreen,
                          fontSize: 30,
                          fontFamily: 'comfortaa',
                          fontWeight: FontWeight.bold,
                        ),),
                        const SizedBox(height: 20,),
                        OfferInfo(offer,context),
                        Divider(
                          color: plastikatGreen,
                          thickness: 1,
                          indent: 30,
                          endIndent: 30,)
                      ],
                    ),
                  );
                }).toList()
            ],
          ),
              )): const CircularProgressIndicator()),
    );
  }
}
