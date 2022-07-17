import 'dart:convert';
import 'dart:ui';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plastikat_client/Pages/HomePage.dart';
import 'package:plastikat_client/services/client_service.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:plastikat_client/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;


class EditProfile extends StatelessWidget
{
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home:MyEditProfile()
    );
  }
}






class MyEditProfile extends StatefulWidget {
  MyEditProfile();

  @override
  _MyEditProfileState createState() => _MyEditProfileState();
}

class  _MyEditProfileState extends State<MyEditProfile> {
  Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);
  TextEditingController? emailController ;
  TextEditingController? nameController ;
  TextEditingController? phoneNumberController;
  TextEditingController? professionController;
  String? name;
  String? email;
  String? phone;
  String? profession;
  String dropdownValue = 'Male';
  bool errorhappened=false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    name = await globals.user.read(key: "name");
    email = await globals.user.read(key: "email");
    phone = await globals.user.read(key: "phone_number");
    profession = await globals.user.read(key: "profession");
    emailController = TextEditingController(text: email);
    nameController = TextEditingController(text: name);
    phoneNumberController = TextEditingController(text: phone);
    professionController = TextEditingController(text: profession);
    setState(() {
      isLoaded = true;
    });
}

  Location location = new Location();
  bool? _serviceEnabled;
  bool _isGetLocation = false;
  PermissionStatus? _permissiongranted;
  LocationData? _locationData;

  void updateProfile() async {
    final ClientService service = ClientService(await globals.secureStorage.read(key: "access_token"));
    String? id = await globals.user.read(key: "id");
    final response = service.updateClient(id!, {
      'name' : nameController!.text,
      'email' : emailController!.text,
      'profession' : professionController!.text,
      'phone_number' : phoneNumberController!.text,
      if (_locationData != null) 'location' : {
        "type" : "point",
        "coordinates" : [_locationData!.longitude , _locationData!.latitude]
      }
    });
    if(await response==204)
      {
        await globals.user.write(
            key: 'name', value: nameController!.text);
        await globals.user.write(
            key: 'email', value: emailController!.text);
        await globals.user.write(
            key: 'phone_number', value: phoneNumberController!.text);
        await globals.user.write(
            key: 'profession', value: professionController!.text);
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                text: "Profile Updated Successfully!"
            )
        );
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage()));
      }
    else
      {
        setState(() {
          errorhappened = true;
        });
      }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          drawer: PlastikatDrawer(),
          appBar: PlastikatBar(),
          body: SingleChildScrollView(
            child: isLoaded ? Container(
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    InputWidget(AppLocalizations.of(context)!.name,nameController,false),
                    InputWidget(AppLocalizations.of(context)!.email,emailController,false),
                    InputWidget(AppLocalizations.of(context)!.mob,phoneNumberController,true),
                    InputWidget(AppLocalizations.of(context)!.profession,professionController,false),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(AppLocalizations.of(context)!.location),
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
                    PlastikatButton(AppLocalizations.of(context)!.save_profile, updateProfile),
                    errorhappened ?  Text(AppLocalizations.of(context)!.error
                      , style: const TextStyle(color: Colors.red),) : const Text("")
                  ],
                )
            ) :  const CircularProgressIndicator()
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
