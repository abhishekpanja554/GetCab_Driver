import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/data_models/driver.dart';
import 'package:uber_clone_driver/globalVariables.dart';
import 'package:uber_clone_driver/helpers/helper_methods.dart';
import 'package:uber_clone_driver/helpers/push_notification_service.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _completer = Completer();
  LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 4,
      timeInterval: 200);

  String availabilityText = 'GO ONLINE';
  Color availabilityColor = BrandColors.colorOrange;
  bool isAvailable = false;

  void getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
  }

  void goOnline() {
    Geofire.initialize('driversAvailable');
    Geofire.setLocation(
        currentUser.uid, currentPosition.latitude, currentPosition.longitude);

    tripRequestRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentUser.uid}/newTrip');

    tripRequestRef.set('waiting');
    tripRequestRef.onValue.listen((event) {});
  }

  void goOffline() {
    Geofire.removeLocation(currentUser.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;
  }

  void getLocationUpdates() {
    positionStream = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 4,
      timeInterval: 200,
    ).listen((Position position) {
      currentPosition = position;

      if (isAvailable) {
        Geofire.setLocation(
          currentUser.uid,
          position.latitude,
          position.longitude,
        );
      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
      mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    });
  }

  void getCurrentDriverInfo() async {
    currentUser = FirebaseAuth.instance.currentUser;
    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentUser.uid}');
    driverRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        currentDriverInfo = Driver.fromSnapshot(snapshot);
      }
    });
    PushNotificatioService pushNotificatioService = PushNotificatioService();
    pushNotificatioService.initialize(context);
    pushNotificatioService.getToken();
    HelperMethods.getHistory(context);
  }

  @override
  void initState() {
    getCurrentDriverInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(
            top: 120,
          ),
          initialCameraPosition: kGooglePlex,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _completer.complete(controller);
            mapController = controller;
            getCurrentPosition();
          },
        ),
        Container(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF3F424B),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
            ),
            height: 120,
            width: double.infinity,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 33,
          ),
          height: 170,
          padding: EdgeInsets.symmetric(
            vertical: 37,
            horizontal: 50,
          ),
          width: double.infinity,
          alignment: Alignment.center,
          child: LiteRollingSwitch(
            value: false,
            textOn: 'ONLINE',
            textOff: 'OFFLINE',
            colorOn: BrandColors.colorGreen,
            colorOff: Color(0xFFF7444E),
            iconOn: Icons.online_prediction,
            iconOff: Icons.power_settings_new_rounded,
            textSize: 16.0,
            onChanged: (bool state) {
              if (state && !isAvailable) {
                goOnline();
                getLocationUpdates();
                setState(() {
                  isAvailable = true;
                });
              } else if (isAvailable && !state) {
                goOffline();
                setState(() {
                  isAvailable = false;
                });
              }
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 20,
          ),
          width: double.infinity,
          height: 100,
          alignment: Alignment.center,
          child: Text(
            'Welcome Driver',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Brand-Regular',
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}
