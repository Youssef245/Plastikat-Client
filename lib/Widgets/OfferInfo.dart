import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:plastikat_client/Pages/OfferPage.dart';
import 'package:plastikat_client/entities/offer.dart';
import 'package:plastikat_client/services/client_service.dart';

class OfferInfo extends StatelessWidget {
  static const Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);
  final ClientOffer offer;
  final BuildContext context;
  String bullet = '\u2022 ';
  OfferInfo(this.offer,this.context);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible( child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listItem('Points', offer.points.toString()),
            if(offer.company!=null) listItem('Company', offer.company!.name),
            if (offer.delegate!=null) listItem('Delegate', offer.delegate!.name),
            listItem('Status', getStatus(offer)),
            TextButton(
              child: const Text('View Full Information',
              style: TextStyle(
                  color: plastikatGreen,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w200,
                  decoration: TextDecoration.underline),
                  ),
              onPressed: (){
                Navigator.of(this.context).push(MaterialPageRoute(
                    builder: (context) => OfferPage(offer)));},
            ),
          ],
        ))
      ],
    );
  }

  Widget listItem(String field, String value) {
    return Text(
      bullet + ' ' + field + ': ' + value,
      style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w200),
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
