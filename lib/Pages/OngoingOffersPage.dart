import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plastikat_client/services/client_service.dart';
import 'package:plastikat_client/services/offer_service.dart';
import '../Widgets/OfferInfo.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'package:plastikat_client/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

class OngoingOffersPage extends StatelessWidget {


  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home:MyOngoingOffersPage()
    );
  }
}



class MyOngoingOffersPage extends StatefulWidget {
  @override
  State<MyOngoingOffersPage> createState() => _MyOngoingOffersPageState();
}

class _MyOngoingOffersPageState extends State<MyOngoingOffersPage> {
  static const  Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);
  List<ClientOffer> initiated = [];
  final String defaultLocale = Platform.localeName.split("_")[0];
  bool isLoaded=false;
  int? i;

  @override
  void initState() {
    super.initState();
    getOffers();
  }

  getOffers() async {
    initiated = [];
    final ClientService service = new ClientService(await globals.secureStorage.read(key: "access_token"));
    print(await globals.secureStorage.read(key: "access_token"));
    String? id = await globals.user.read(key: "id");
    List<ClientOffer> offers = await service.getClientOffers(id!);
    for (ClientOffer offer in offers)
    {
      if(offer.status=="INITIATED"||offer.status=='COMPANY_ASSIGNED'||offer.status=='DELEGATE_ASSIGNED') {
        initiated.add(offer);
        print(offer.points);
      }
    }
    setState(() {
      isLoaded = true;
    });
  }

  cancelOffer(String offerID) async {
    String? accessToken = await globals.secureStorage.read(key: "access_token");
    final OfferService service = OfferService (accessToken!);
    final response = await service.cancelOffer(offerID);
    print(response);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    i=0;
    return Scaffold(
          drawer: PlastikatDrawer(),
          appBar: PlastikatBar(),
          body: isLoaded? SingleChildScrollView(
              child: Column(
                children: [
                  if(initiated.isEmpty)
                    const Center(
                        child: Text("You have made no ongoing offers yet",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'comfortaa',
                            fontWeight: FontWeight.w300,
                          ),)
                    )
                  else
                    ...initiated.map((offer) {
                    i = i!+1;
                    return Stack(
                        children: [
                        Positioned(
                        top: 10,
                        right: defaultLocale=='en' ? 10 : null,
                        left: defaultLocale=='ar' ? 10 : null,
                        child: TextButton(
                          child: const Icon(Icons.cancel, color: Colors.red,
                            size: 30,),
                          onPressed: () async {
                            final response = cancelOffer(offer.id);
                            if(await response==204)
                            {
                              ArtSweetAlert.show(
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                      type: ArtSweetAlertType.success,
                                      text: AppLocalizations.of(context)!.offer_cancel
                                  )
                              );
                              setState(() {
                                getOffers();
                              });
                            }
                          },
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: defaultLocale=='en' ? const EdgeInsets.only(left: 20.0) : const EdgeInsets.only(right: 20.0),
                          child: Text("${AppLocalizations.of(context)!.offer_No} ${i}",
                            style: const TextStyle(
                              color: plastikatGreen,
                              fontSize: 20,
                              fontFamily: 'comfortaa',
                              fontWeight: FontWeight.bold,
                            ),),
                        ),
                      const SizedBox(height: 20,),
                      OfferInfo(offer,context),
                      const Divider(
                          color: plastikatGreen,
                          thickness: 1,
                          indent: 30,
                          endIndent: 30,)
                      ],
                      ),
                    ),
                    ],
                    );
                  }).toList()
                ],
              )): const CircularProgressIndicator());
  }
}
