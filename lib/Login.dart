import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plastikat_client/Pages/HomePage.dart';
import 'package:plastikat_client/Pages/LoginPage.dart';
import 'package:plastikat_client/entities/common/device_token.dart';
import 'package:plastikat_client/services/client_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/SignUpPage.dart';
import 'globals.dart' as globals;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


/// -----------------------------------
///           Auth0 Variables
/// -----------------------------------

final auth0Domain = "plastikat.eu.auth0.com";
final auth0ClientId = "s0H9qSaWDZojXEP5bnW8Idb7i8YDgj7h";
final auth0RedirectUri = "com.plastikat.client://login-callback";
final auth0Issuer = "https://$auth0Domain";

///-----------------------------------------
///       Login
/// ----------------------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Login(false));
}

class Login extends StatefulWidget {
  bool logout;
  Login(this.logout);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isBusy = false;
  bool isLoggedIn = false;
  bool isSignedUp = false;
  String errorMessage = "";
  var passedInformation;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: isBusy
              ? const CircularProgressIndicator()
              : isSignedUp
              ? SignUpPage(passedInformation)
              : isLoggedIn
              ? HomePage()
              : LoginPage(loginAction,errorMessage),
        ),
      ),
    );
  }

    Map<String, dynamic> parseIdToken(String? idToken) {
    if (idToken == null) throw Exception('idToken cannot be null');

    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, dynamic>> getUserDetails(String? accessToken) async {
    if (accessToken == null) throw Exception('accessToken is null');
    final response = await http.get(
      Uri.parse('https://$auth0Domain/userinfo'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse? result =
      await globals.appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(auth0ClientId, auth0RedirectUri,
            issuer: 'https://$auth0Domain',
            scopes: ['openid', 'profile','email', 'offline_access'],
            promptValues: ['login'],
            additionalParameters: {'audience': 'plastikat-app-api'}),
      );

      if (result != null) {
         final parsedToken = parseIdToken(result.idToken);

        String userID = parsedToken['sub'];

        final httpRes = await http.get(
            Uri.parse('http://164.92.248.132/api/clients/$userID'),
            headers: {
              'authorization': 'Bearer ${result.accessToken}',});
        if (httpRes.statusCode != 404)  {
          final userInformation = jsonDecode(httpRes.body);
          await globals.user.write(
              key: 'id', value: userInformation['data']['_id']);
          await globals.user.write(
              key: 'name', value: userInformation['data']['name']);
          await globals.user.write(
              key: 'email', value: userInformation['data']['email']);
          await globals.user.write(
              key: 'phone_number', value: userInformation['data']['phone_number']);
          await globals.user.write(
              key: 'birth_date', value: userInformation['data']['birth_date']);
          await globals.user.write(
              key: 'gender', value: userInformation['data']['gender']);
          await globals.user.write(
              key: 'points', value: userInformation['data']['points'].toString());
         await globals.user.write(
              key: 'address', value: userInformation['data']['address']['formattedAddress']);
          await globals.user.write(
              key: 'profession', value: userInformation['data']['profession']);

          final ClientService service = ClientService(result!.accessToken!);
          FirebaseMessaging _fcm = FirebaseMessaging.instance;
          final dTokenString = await _fcm.getToken();
          DeviceToken dToken = DeviceToken(dTokenString!,'Android',DateTime.now().toString());
          service.updateClientTokens(userInformation['data']['_id'], dToken);
        }


        await globals.secureStorage.write(
            key: 'access_token', value: result.accessToken);

        await globals.secureStorage.write(
            key: 'refresh_token', value: result.refreshToken);

        print(await globals.secureStorage.read(key: "access_token"));

         if (httpRes.statusCode != 404)
         {
           setState(() {
             isBusy = false;
             isLoggedIn = true;
           });
         }
         else
         {
           setState(() {
             isBusy = false;
             isSignedUp = true;
             passedInformation = parsedToken;
           });
         }
      }
    } catch (e, s) {
      log('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> logoutAction() async {
    await globals.secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.logout)
      logoutAction();
    initAction();
  }

  void initAction() async {
    final storedRefreshToken = await globals.secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    setState(() {
      isBusy = true;
    });

    try {
      final response = await globals.appAuth.token(TokenRequest(
        auth0ClientId,
        auth0RedirectUri,
        issuer: auth0Issuer,
        refreshToken: storedRefreshToken,
      ));

      if (response != null) {
        final idToken = parseIdToken(response.idToken);
        final profile = await getUserDetails(response.accessToken);

        globals.secureStorage.write(key: 'refresh_token', value: response.refreshToken);

        setState(() {
          isBusy = false;
          isLoggedIn = true;
        });
      }
    } catch (e, s) {
      log('error on refresh token: $e - stack: $s');
      logoutAction();
    }
  }
}