import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plastikat_client/Pages/EditProfile.dart';
import 'package:plastikat_client/Pages/HomePage.dart';
import 'package:plastikat_client/Pages/LoginPage.dart';
import 'package:plastikat_client/Pages/PublishOffer.dart';
import 'package:plastikat_client/Pages/SendComplaint.dart';
import 'Login.dart';
import 'globals.dart' as globals;

void main () async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: Login(false),));
}

