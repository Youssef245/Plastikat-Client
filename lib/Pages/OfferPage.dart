import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plastikat_client/entities/offer.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/client_service.dart';
import 'SendComplaint.dart';

class OfferPage extends StatelessWidget {
  static const Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);
  final String assetName = 'images/569509_main (1).jpg';
  var types =  ['Small Bottle','Small Bottle','Small Bottle','Small Bottle','Small Bottle','Small Bottle','Small Bottle','Small Bottle','Small Bottle'
    ,'Small Bottle','Small Bottle','Small Bottle','Small Bottle'];
  String bullet = '\u2022 ';
  final ClientOffer offer;

  OfferPage(this.offer);

  void dostuff() {
    print('foo');
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
                child: Column(
                  children: [
                    offerFullInformation(context),
                  ],
                ))),
      ),
    );
  }

  Widget OfferItem(String field, String value,double size,MainAxisAlignment alignment, IconData icon) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Icon(
          icon,
          color: plastikatGreen,
          size: size,
        ),
        const SizedBox(width: 10,),
        Flexible(
          child: Text(
            field + ': ' + value,
            style: TextStyle(
                color: Colors.black,
                fontSize: size,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300),
          ),
        )
      ],
    );
  }

  Widget offerFullInformation(BuildContext context)
  {
    return Container(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        children: [
          if(offer.company!=null) OfferItem('Company', offer.company!.name ,20,MainAxisAlignment.start,Icons.apartment),
          const SizedBox(height: 10),
          if(offer.delegate!=null) OfferItem('Delegate', offer.delegate!.name ,20,MainAxisAlignment.start,Icons.person),
          const SizedBox(height: 10),
          OfferItem('Points', '${offer.points.toString()} point',20,MainAxisAlignment.start,Icons.wallet_giftcard),
          const SizedBox(height: 10),
          OfferItem('Status', getStatus(offer) ,20,MainAxisAlignment.start,Icons.apartment),
          const SizedBox(height: 10),
          Column(
            children: [
              ...offer.items.map((item) {
                return Column(
                  children: [
                    OfferItem('Name', item.name,16,MainAxisAlignment.center,Icons.drive_file_rename_outline),
                    const SizedBox(width: 10,),
                    OfferItem('Type', item.type,16,MainAxisAlignment.center,Icons.vignette_sharp),
                    const SizedBox(width: 10,),
                    OfferItem('Quantity', item.quantity.toString(),16,MainAxisAlignment.center,Icons.numbers),
                    const Divider(
                      color: plastikatGreen,
                      thickness: 1,
                      indent: 30,
                      endIndent: 30,)
                  ],
                );
              }).toList(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if(offer.delegate!=null) TextButton(
                    child: const Text('Report Delegate',
                      style: TextStyle(
                          color: plastikatGreen,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w200,
                          decoration: TextDecoration.underline),
                    ),
                    onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SendComplaint(offer.delegate!.id)));
                    },
                  ),
                  if(offer.company!=null) TextButton(
                    child: const Text('Report Company',
                      style: TextStyle(
                          color: plastikatGreen,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w200,
                          decoration: TextDecoration.underline),
                    ),
                    onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SendComplaint(offer.company!.id)));
                    },
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  String getStatus (ClientOffer offer)
  {
    if(offer.status=="COMPLETED")   return "Collected";
    else if(offer.status=="DELEGATE_ASSIGNED") return "Delegate Assigned";
    else if(offer.status=="COMPANY_ASSIGNED") return "Company Assigned";
    else if(offer.status=="INITIATED") return "Pending";
    else if(offer.status=="CANCELED"&&offer.delegate==null) return "Canceled";
    else return "Rejected";

  }

}