import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_driver/data_models/trip_details.dart';
import 'package:uber_clone_driver/globalVariables.dart';
import 'package:uber_clone_driver/widgets/notification_dialog.dart';
import 'package:uber_clone_driver/widgets/progress_dialog.dart';

class PushNotificatioService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future initialize(context) async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        getRideInfo(getId(message), context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        getRideInfo(getId(message), context);
      },
      onResume: (Map<String, dynamic> message) async {
        getRideInfo(getId(message), context);
      },
    );
  }

  String getId(Map<String, dynamic> message) {
    String rideId;
    rideId = message['data']['ride_id'];
    return rideId;
  }

  void getRideInfo(String rideId, context) {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,	
      context: context,	
      builder: (BuildContext context) => ProgressDialog(	
        status: 'Fetching Details',	
      ),	
    );

    DatabaseReference rideRef =
        FirebaseDatabase.instance.reference().child('rideRequest/$rideId');
    rideRef.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);
      if (snapshot.value != null) {
        assetAudioPlayer.open(
          Audio('sounds/alert.mp3'),
        );

        assetAudioPlayer.play();

        double pickupLat =
            double.parse(snapshot.value['pickup']['latitude'].toString());
        double pickupLng =
            double.parse(snapshot.value['pickup']['longitude'].toString());
        String pickupAddr = snapshot.value['pickup_address'].toString();

        double destinationLat =
            double.parse(snapshot.value['destination']['latitude'].toString());
        double destinationLng =
            double.parse(snapshot.value['destination']['longitude'].toString());
        String destinationAddr =
            snapshot.value['destination_address'].toString();
        String riderName = snapshot.value['rider_name'];

        String paymentMethod = snapshot.value['payment_method'];

        TripDetails tripDetails = TripDetails();
        tripDetails.rideId = rideId;
        tripDetails.destinationAddress = destinationAddr;
        tripDetails.destinationCoordinates =
            LatLng(destinationLat, destinationLng);
        tripDetails.pickupAddress = pickupAddr;
        tripDetails.riderName = riderName;
        tripDetails.pickupCoordinates = LatLng(pickupLat, pickupLng);
        tripDetails.paymentMethod = paymentMethod;

        showDialog(
          context: context,	
          barrierDismissible: false,	
          builder: (BuildContext context) => NotificationDialog(	
            tripDetails: tripDetails,	
          ),	
        );
      }
    });
  }

  Future getToken() async {
    String token = await _firebaseMessaging.getToken();
    DatabaseReference tokenref = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentUser.uid}/token');
    tokenref.set(token);
    print("token:$token");
    _firebaseMessaging.subscribeToTopic('allDrivers');
    _firebaseMessaging.subscribeToTopic('allUsers');
  }
}
