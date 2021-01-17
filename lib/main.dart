import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/data_provider.dart';
import 'package:uber_clone_driver/screens/history_page.dart';
import 'package:uber_clone_driver/screens/login_page.dart';
import 'package:uber_clone_driver/screens/main_page.dart';
import 'package:uber_clone_driver/screens/registration_page.dart';
import 'package:uber_clone_driver/screens/vehicleInfo_page.dart';

import 'globalVariables.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: '1:766136102335:android:0acce4523d3064146ac50a',
            apiKey: 'AIzaSyDu3LOP9fTpiL-Vaa6YECeNDJNb8FFEhqw',
            projectId: 'flutter-firebase-plugins',
            messagingSenderId: '297855924061',
            databaseURL: 'https://geetaxi-5e2be.firebaseio.com',
          )
        : FirebaseOptions(
            appId: '1:766136102335:android:390b7e3d49fa69366ac50a',
            apiKey: 'AIzaSyDu3LOP9fTpiL-Vaa6YECeNDJNb8FFEhqw',
            messagingSenderId: '297855924061',
            projectId: 'flutter-firebase-plugins',
            databaseURL: 'https://geetaxi-5e2be.firebaseio.com',
          ),
  );
  currentUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'GetCab Driver',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Brand-Regular',
        ),
        initialRoute: (currentUser == null) ? LoginPage.id : MainPage.id,
        routes: {
          MainPage.id: (context) => MainPage(),
          RegistrationPage.id: (context) => RegistrationPage(),
          VehicleInfoPage.id: (context) => VehicleInfoPage(),
          LoginPage.id: (context) => LoginPage(),
          HistoryPage.id: (context) => HistoryPage(),
        },
      ),
    );
  }
}
