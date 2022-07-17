import 'dart:math';
import 'dart:ui';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plastikat_client/Pages/PointsPage.dart';
import 'package:plastikat_client/entities/partner.dart';
import 'package:plastikat_client/services/exchange_service.dart';
import 'package:plastikat_client/services/partner_service.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plastikat_client/globals.dart' as globals;

import 'HomePage.dart';

class ViewPartner extends StatefulWidget {
  String partnerID;
  int points;

  ViewPartner(this.partnerID,this.points);

  @override
  State<ViewPartner> createState() => _ViewPartnerState();
}

class _ViewPartnerState extends State<ViewPartner> {
  Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);
  final String assetName = 'images/Placeholder.jpg';
  String bullet = '\u2022 ';
  bool isLoaded = false;
  Partner? partner;


  @override
  void initState() {
    super.initState();
    getPartnerData();
  }

  getPartnerData() async {
    final PartnerService service =  PartnerService();
    partner = await service.getPartnerById(widget.partnerID);
    setState(() {
      isLoaded = true;
    });
  }

  createExchange(String rewardID) async {
    String? accessToken = await globals.secureStorage.read(key: "access_token");
    String? id = await globals.user.read(key: "id");
    final ExchangeService service = ExchangeService(accessToken!);
    final response = await service.exchangeReward({
      'client' : id,
      'partner' : partner!.id,
      'reward' : rewardID
    });
    return response;
  }

  String generateRandomString(int length) {
    final _random = Random();
    const _availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();

    return randomString;
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: PlastikatDrawer(),
        appBar: PlastikatBar(),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(top: 40),
                alignment: Alignment.center,
                child: isLoaded ? Column(
                  children: [
                    Image.asset(
                      assetName,
                      height: 148,
                      width: 239,
                    ),
                    const SizedBox(height: 20),
                    PartnerFullInformation(),
                  ],
                ):const CircularProgressIndicator())),
      ),
    );
  }

  Widget textWidget(String value) {
    return Text(
      value,
      style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300),
    );
  }
  Widget titleWidget(String field) {
    return Text(
      bullet + ' ' + field,
      style: TextStyle(
          color: plastikatGreen,
          fontSize: 20,
          fontFamily: 'comfortaa',
          fontWeight: FontWeight.bold),
    );
  }

  Widget PartnerFullInformation()
  {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget('Description'),
          const SizedBox(height: 15),
          textWidget(partner!.description),
          const SizedBox(height: 15),
          titleWidget('Rewards'),
          const SizedBox(height: 20),
          SingleChildScrollView(
            child: Column(
              children: [
                ...partner!.rewards!.map((reward) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(reward.name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(width: 15,),
                            Text("Points : ${reward.points.toString()}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(width: 15,),
                            TextButton(
                              child: Text('Claim Reward',
                                style: TextStyle(
                                    color: plastikatGreen,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w200,
                                    decoration: TextDecoration.underline),
                              ),
                              onPressed: () async {
                                if(widget.points>=reward.points!)
                                {
                                  ArtSweetAlert.show(
                                      context: context,
                                      artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.success,
                                          text: "Save the Voucher!\n${generateRandomString(10)}"
                                      )
                                  );
                                  createExchange(reward.id);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => HomePage()));
                                }
                                else
                                {
                                  ArtSweetAlert.show(
                                      context: context,
                                      artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.danger,
                                          text: "Sorry, You Don't have enough points!"
                                      )
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Divider(
                          color: plastikatGreen,
                          thickness: 1,
                          indent: 0,
                          endIndent: 60,)
                      ],
                    ),
                  );
                }).toList()
              ],
            ),
          )
          ],
      ),
    );
  }
}