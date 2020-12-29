import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_driver/data_models/direction_details.dart';
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

  static int estimateFairs(DirectionDetails details) {
    double baseFare = 80;
    double distanceFare = (details.distanceValue / 1000) * 8;
    double timeFare = (details.durationValue / 60) * 5;

    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static double randomNumberGenerator(int max) {
    var randonGen = Random();
    int rand = randonGen.nextInt(max);
    return rand.toDouble();
  }

  static void disableLocationSubscription(){
    positionStream.pause();
    Geofire.removeLocation(currentUser.uid);
  }

  static void enableLocationSubscription(){
    positionStream.resume();
    Geofire.setLocation(currentUser.uid, currentPosition.latitude, currentPosition.longitude);
  }

  static void showProgressDialog(context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Please wait...',
      ),
    );
  }
}
