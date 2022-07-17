import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plastikat_client/Pages/ViewPartner.dart';
import 'package:plastikat_client/entities/partner.dart';
import 'package:plastikat_client/services/partner_service.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PartnersPage extends StatefulWidget {
  int points;

  PartnersPage(this.points);

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);
  bool isLoaded = false;
  List<Partner>? partners;

  var assetName = 'images/Placeholder.jpg';

  @override
  void initState() {
    super.initState();
    getPartners();
  }

  getPartners() async {
    final PartnerService service = new PartnerService();
    partners = await service.getPartners();
    if(partners!.length % 2!=0)
    {
      partners!.add(Partner.empty('0','0','0'));
    }
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
        body: SingleChildScrollView(
          child: isLoaded ? Column(
            children: [
              for(var i =0 ; i<partners!.length;i=i+2) OneRow(partners![i],partners![i+1],context),
            ],
          ) : const CircularProgressIndicator()
        ),
      ),
    );
  }

  Widget OneRow (Partner fisrtValue,Partner secondValue,BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if(fisrtValue.id!='0') partnerWidget(fisrtValue,context),
        if(secondValue.id!='0') partnerWidget(secondValue,context),
      ],
    );
  }

  Widget partnerWidget(Partner value,BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ViewPartner(value.id,widget.points!))),
      child: Column(
        children: [
          Card(
            child: Container( child : Column(
              children: [
                const SizedBox(height: 10),
                Image.asset(assetName,
                  height: 87,
                  width: 82,),
                const SizedBox(height: 10),
              ],
            ),
            padding: EdgeInsets.only(left: 20,right: 20)
            ),
            color: Color.fromRGBO(255, 255, 255, 100),
            elevation: 1,
          ),
          const SizedBox(height: 10),
          nameWidget(value.name),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget nameWidget(String name) {
    return Container(
        padding: EdgeInsets.only(left: 10),
        child : SizedBox(
            width: 120,
            child : Text(name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500))));
  }
}
