import 'dart:convert';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plastikat_client/Pages/HomePage.dart';
import 'package:plastikat_client/entities/common/device_token.dart';
import 'package:plastikat_client/services/client_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:plastikat_client/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

class SignUpPage extends StatelessWidget {
  final userInformation;
  SignUpPage(this.userInformation);

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home:MySignUpPage(userInformation)
    );
  }
}


class MySignUpPage extends StatefulWidget {
  final userInformation;
  MySignUpPage(this.userInformation);

  @override
  _MySignUpPageState createState() => _MySignUpPageState();
}

class  _MySignUpPageState extends State<MySignUpPage> {
  Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);
   TextEditingController? emailController ;
   TextEditingController? nameController ;
   TextEditingController? phoneNumberController;
   TextEditingController? professionController;
   String dropdownValue = 'Male';
   bool errorhappened=false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.userInformation['email']);
    nameController = TextEditingController(text: widget.userInformation['name']);
    phoneNumberController = TextEditingController();
    professionController = TextEditingController();
  }

  static DateTime now =  DateTime.now();
  DateTime date =  DateTime(now.year, now.month, now.day);

  Location location = new Location();
  bool? _serviceEnabled;
  bool _isGetLocation = false;
  PermissionStatus? _permissiongranted;
  LocationData? _locationData;

  void SignUp () async {
    final httpRes = await http.post(
      Uri.parse('http://164.92.248.132/api/clients'),
      headers: {
        'authorization': 'Bearer ${await globals.secureStorage.read(key: 'access_token')}',
        'content-type' : 'application/json'},
      body: jsonEncode({
        'sub' : widget.userInformation['sub'],
        'name' : nameController!.text,
        'email' : emailController!.text,
        'birth_date' : date.toString(),
        'gender' : dropdownValue,
        'profession' : professionController!.text,
        'phone_number': phoneNumberController!.text,
        'location' : {
          "type" : "point",
          "coordinates" : [_locationData!.longitude , _locationData!.latitude] }
      }), );
    print(httpRes.statusCode);
    if(httpRes.statusCode!=201)
    {
      setState(() {
        errorhappened = true;
      });
    }
    else
    {
      await globals.user.write(
          key: 'id', value: widget.userInformation['sub']);
      await globals.user.write(
          key: 'name', value: nameController!.text);
      await globals.user.write(
          key: 'email', value: emailController!.text);
      await globals.user.write(
          key: 'phone_number', value: phoneNumberController!.text);
      await globals.user.write(
          key: 'birth_date', value: date.toString());
      await globals.user.write(
          key: 'gender', value: dropdownValue);
      await globals.user.write(
          key: 'points', value: "0");
      await globals.user.write(
          key: 'profession', value: professionController!.text);

      final ClientService service = ClientService(await globals.secureStorage.read(key: 'access_token'));
      FirebaseMessaging _fcm = FirebaseMessaging.instance;
      final dTokenString = await _fcm.getToken();
      DeviceToken dToken = DeviceToken(dTokenString!,'Android',DateTime.now().toString());
      service.updateClientTokens(widget.userInformation['sub'], dToken);
      Navigator.of(context);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage()));
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          drawer: PlastikatDrawer(),
          appBar: PlastikatBar(),
          body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    InputWidget(AppLocalizations.of(context)!.name,nameController,false),
                    InputWidget(AppLocalizations.of(context)!.email,emailController,false),
                    InputWidget(AppLocalizations.of(context)!.mob,phoneNumberController,true),
                    InputWidget(AppLocalizations.of(context)!.profession,professionController,false),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: plastikatGreen,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Male','Female']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget('${date.year}/${date.month}/${date.day}'),
                        IconButton(
                          icon: Icon(Icons.date_range , color: plastikatGreen),
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(1900),
                              lastDate: date);

                          if(newDate == null) return;

                          setState(() {
                            date = newDate;
                          });
                          },
                        )
                      ],
                    ),Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(AppLocalizations.of(context)!.submit_location),
                        IconButton(
                          icon: Icon(Icons.location_on,color: plastikatGreen,),
                          onPressed: () async{
                            _serviceEnabled = await location.serviceEnabled();
                            if (!_serviceEnabled!) {
                              _serviceEnabled = await location.requestService();
                              if (!_serviceEnabled!) {
                                return;
                              }
                            }
                            _permissiongranted = await location.hasPermission();
                            if (_permissiongranted == PermissionStatus.denied) {
                              _permissiongranted = await location.requestPermission();
                              if (_permissiongranted != PermissionStatus.granted) {
                                return;
                              }
                            }

                            _locationData = await location.getLocation();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    PlastikatButton(AppLocalizations.of(context)!.sign_up, SignUp),
                    errorhappened ? Text(AppLocalizations.of(context)!.error
                    , style: const TextStyle(color: Colors.red),) : const Text("")
                  ],
                )
            ),
          )
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

  Widget InputWidget (String label, TextEditingController? controller, bool numbers)
  {

    return Container(
      height: 90,
      padding: EdgeInsets.all(20),
      child: TextFormField(
        controller: controller,
        cursorColor: plastikatGreen,
        keyboardType: numbers ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide:  BorderSide(width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide:  BorderSide(color: plastikatGreen, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),

          label: Text(
              label,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500)
          ),
        ),
      ),
    );
  }

}
