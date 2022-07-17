import 'dart:ui';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plastikat_client/Pages/HomePage.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plastikat_client/globals.dart' as globals;

import '../services/complaint_service.dart';

class SendComplaint extends StatefulWidget {
  String defendantID;

  SendComplaint(this.defendantID);

  @override
  State<SendComplaint> createState() => _SendComplaintState();
}

class _SendComplaintState extends State<SendComplaint> {
  bool showPassword = false;
  TextEditingController? complaintController = TextEditingController();
  Color plastikatGreen = const Color.fromRGBO(10, 110, 15, 100);

  sendComplaint () async {
    String? accessToken = await globals.secureStorage.read(key: "access_token");
    String? id = await globals.user.read(key: "id");
    final ComplaintService service = ComplaintService(accessToken!);
    if(complaintController!.text!=null) {
      final response = await service.initiateComplaint(id!, {
        "claimant": id,
        "defendant": widget.defendantID,
        "complaint": complaintController!.text
      });
      if (response == 201) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                text: "Complaint Sent Successfully!"
            )
        );
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          drawer: PlastikatDrawer(),
          appBar: PlastikatBar(),
          body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 30,),
                    TextField(
                      controller: complaintController,
                      minLines: 6,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide:  BorderSide(width: 2.0),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderSide:  BorderSide(color: plastikatGreen, width: 2.0),
                          ),
                          hintText: "Write Your Complaint"
                      ),
                    ),
                    const SizedBox(height: 30,),
                    PlastikatButton('Send Complaint', sendComplaint)
                  ],
                )
            ),
          )
      ),
    );
  }

  Widget TextWidget(String name) {
    return Text(name,
        style: TextStyle(
            color: plastikatGreen,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline));
  }

  Widget InputWidget (String value,String label,bool isSecured)
  {

    return Container(
      height: 90,
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        obscureText: isSecured ? showPassword : false ,
        initialValue: value,
        cursorColor: plastikatGreen,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide:  BorderSide(width: 2.0),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide:  BorderSide(color: plastikatGreen, width: 2.0),
          ),
          hintText: "Title"
        ),
      ),

    );
  }
}
