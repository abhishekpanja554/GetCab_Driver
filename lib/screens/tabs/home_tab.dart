import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/data_models/driver.dart';
import 'package:uber_clone_driver/globalVariables.dart';
import 'package:uber_clone_driver/helpers/push_notification_service.dart';
import 'package:uber_clone_driver/widgets/availability_button.dart';
import 'package:uber_clone_driver/widgets/confirm_sheet.dart';

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
    DatabaseReference driverRef = FirebaseDatabase.instance.reference().child('drivers/${currentUser.uid}');
    driverRef.once().then((DataSnapshot snapshot) {
      if(snapshot.value != null){
        currentDriverInfo = Driver.fromSnapshot(snapshot);
      }
    });
    PushNotificatioService pushNotificatioService = PushNotificatioService();
    pushNotificatioService.initialize(context);
    pushNotificatioService.getToken();
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
            top: 135,
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
          height: 135,
          width: double.infinity,
          color: BrandColors.colorPrimary,
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvailabilityButton(
                buttonText: availabilityText,
                color: availabilityColor,
                onPressed: () {
                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (BuildContext context) => ConfirmSheet(
                      title: !isAvailable ? 'GO ONLINE' : 'GO OFFLINE',
                      subTitle: !isAvailable
                          ? 'You are about to become available to recieve trip requests'
                          : 'You will stop recieving requests',
                      onPressed: () {
                        if (!isAvailable) {
                          goOnline();
                          getLocationUpdates();
                          Navigator.pop(context);
                          setState(() {
                            availabilityColor = BrandColors.colorGreen;
                            availabilityText = 'GO OFFLINE';
                            isAvailable = true;
                          });
                        } else {
                          goOffline();
                          Navigator.pop(context);
                          setState(() {
                            availabilityColor = BrandColors.colorOrange;
                            availabilityText = 'GO ONLINE';
                            isAvailable = false;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
