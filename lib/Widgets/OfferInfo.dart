import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:plastikat_client/Pages/OfferPage.dart';
import 'package:plastikat_client/entities/offer.dart';
import 'package:plastikat_client/services/client_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

class OfferInfo extends StatelessWidget {
  final ClientOffer offer;
  final BuildContext context;
  OfferInfo(this.offer,this.context);

  Widget build(BuildContext context) {
    return MyOfferInfo(offer,context);
  }
}



class MyOfferInfo extends StatelessWidget {
  static const Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);
  final ClientOffer offer;
  final BuildContext context;
  String bullet = '\u2022 ';
  MyOfferInfo(this.offer,this.context);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible( child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listItem(AppLocalizations.of(context)!.points, offer.points.toString()),
            if(offer.company!=null) listItem(AppLocalizations.of(context)!.company, offer.company!.name),
            if (offer.delegate!=null) listItem(AppLocalizations.of(context)!.del, offer.delegate!.name),
            listItem(AppLocalizations.of(context)!.status, getStatus(offer)),
            TextButton(
              child:  Text(AppLocalizations.of(context)!.view_full,
              style: const TextStyle(
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
      style: const TextStyle(
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
