import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/data_models/direction_details.dart';
import 'package:uber_clone_driver/data_models/driver.dart';
import 'package:uber_clone_driver/data_models/history.dart';
import 'package:uber_clone_driver/data_provider.dart';
import 'package:uber_clone_driver/helpers/network_helper.dart';
import 'package:uber_clone_driver/widgets/progress_dialog.dart';

import '../globalVariables.dart';

class HelperMethods {
  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPos, LatLng endPos) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPos.latitude},${startPos.longitude}&destination=${endPos.latitude},${endPos.longitude}&mode=driving&key=$apiKey';

    var response = await RequestHelper.getRequest(url);

    if (response == 'Failed') {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  static int estimateFairs(DirectionDetails details, int durationVal) {
    double baseFare = 80;
    double distanceFare = (details.distanceValue / 1000) * 8;
    double timeFare = (durationVal / 60) * 5;

    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static double randomNumberGenerator(int max) {
    var randonGen = Random();
    int rand = randonGen.nextInt(max);
    return rand.toDouble();
  }

  static void getLatestDriverInfo(context) {
    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentUser.uid}');
    driverRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        currentDriverInfo = Driver.fromSnapshot(snapshot);
        Provider.of<AppData>(context, listen: false)
            .updateLatestInfo(currentDriverInfo);
      }
    });
  }

  static void disableLocationSubscription() {
    positionStream.pause();
    Geofire.removeLocation(currentUser.uid);
  }

  static void enableLocationSubscription() {
    positionStream.resume();
    Geofire.setLocation(
        currentUser.uid, currentPosition.latitude, currentPosition.longitude);
  }

  static void showProgressDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Please wait...',
      ),
    );
  }

  static void getHistory(context) {
    DatabaseReference historyRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentUser.uid}/ride_history');
    historyRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        int tripCount = values.length;

        // update trip count to data provider
        Provider.of<AppData>(context, listen: false).updateTripCount(tripCount);

        List<String> tripHistoryKeys = [];
        values.forEach((key, value) {
          tripHistoryKeys.add(key);
        });

        // update trip keys to data provider
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);

        getHistoryData(context);
      }
    });
  }

  static void getHistoryData(context) {
    totalEarning = 0;
    Provider.of<AppData>(context, listen: false)
        .updateEarnings(totalEarning.toString());
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;
    Provider.of<AppData>(context, listen: false).updateTripHistory(null);

    for (String key in keys) {
      DatabaseReference historyRef =
          FirebaseDatabase.instance.reference().child('rideRequest/$key');

      historyRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          History history = History.fromSnapshot(snapshot);
          totalEarning = totalEarning + int.parse(history.fares);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistory(history);
          Provider.of<AppData>(context, listen: false)
              .updateEarnings(totalEarning.toString());
        }
      });
    }
  }

  static String dateFormatter(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    String formattedDateStr =
        '${DateFormat.MMMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}';
    return formattedDateStr;
  }
}
