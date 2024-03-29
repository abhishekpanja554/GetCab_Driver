import 'dart:async';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/data_models/trip_details.dart';
import 'package:uber_clone_driver/helpers/helper_methods.dart';
import 'package:uber_clone_driver/helpers/map_toolkit_helper.dart';
import 'package:uber_clone_driver/widgets/payment_dialog.dart';
import 'package:uber_clone_driver/widgets/progress_dialog.dart';
import 'package:uber_clone_driver/widgets/taxi_button.dart';

import '../globalVariables.dart';

class NewTripPage extends StatefulWidget {
  final TripDetails tripDetails;
  NewTripPage({this.tripDetails});

  @override
  _NewTripPageState createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  GoogleMapController tripMapController;

  Completer<GoogleMapController> _completer = Completer();

  Set<Marker> _markers = Set<Marker>();

  Set<Circle> _circles = Set<Circle>();

  Set<Polyline> _polylines = Set<Polyline>();

  List<LatLng> polylinesCoordinatesList = [];

  PolylinePoints polylinePoints = PolylinePoints();

  Geolocator geolocator = Geolocator();

  LocationOptions locationOptions =
      LocationOptions(accuracy: LocationAccuracy.bestForNavigation);

  Position carPosition;

  BitmapDescriptor movingCarIcon;

  String driverStatus = 'accepted';

  String durationString = '';

  bool isdirectionRequesting = false;

  String buttonTitle = 'ARRIVED';

  Color buttonColor = BrandColors.colorGreen;

  Timer timer;

  int timeCounter = 0;

  void createMarker() {
    if (movingCarIcon == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
        context,
        size: Size(2, 2),
      );

      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'images/car_android.png')
          .then((icon) {
        movingCarIcon = icon;
      });
    }
  }

  @override
  void initState() {
    acceptTrip();
    super.initState();
  }

  void acceptTrip() {
    String rideId = widget.tripDetails.rideId;
    rideRef =
        FirebaseDatabase.instance.reference().child('rideRequest/$rideId');
    rideRef.child('status').set('accepted');
    rideRef.child('driver_name').set(currentDriverInfo.fullName);
    rideRef.child('phone').set(currentDriverInfo.phone);
    rideRef.child('car_model').set(currentDriverInfo.carModel);
    rideRef.child('car_color').set(currentDriverInfo.carColor);
    rideRef.child('vehicle_number').set(currentDriverInfo.vehicleNumber);
    rideRef.child('driver_id').set(currentDriverInfo.id);

    Map locationMap = {
      'latitude': currentPosition.latitude.toString(),
      'longitude': currentPosition.longitude.toString(),
    };

    rideRef.child('driver_location').set(locationMap);

    DatabaseReference rideHistoryRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentUser.uid}/ride_history/$rideId');

    rideHistoryRef.set('true');
  }

  void endTrip() async {
    timer.cancel();
    HelperMethods.showProgressDialog(context);
    LatLng currentLatLng = LatLng(carPosition.latitude, carPosition.longitude);
    var directionDetails = await HelperMethods.getDirectionDetails(
        widget.tripDetails.pickupCoordinates, currentLatLng);
    Navigator.pop(context);
    int fares = HelperMethods.estimateFairs(directionDetails, timeCounter);
    rideRef.child('fare').set(fares.toString());
    rideRef.child('status').set('completed');
    carPositionStream.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => PaymentDialog(
        paymentMethod: widget.tripDetails.paymentMethod,
        fare: fares,
      ),
    );
    HelperMethods.getHistory(context);
    totalEarnings(fares);
  }

  Future<void> getDirection(LatLng pickLatLng, LatLng destLatLng) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Please wait...',
      ),
    );

    var thisDetails =
        await HelperMethods.getDirectionDetails(pickLatLng, destLatLng);

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);

    polylinesCoordinatesList.clear();

    if (results.isNotEmpty) {
      // loop through all pointLatLng points and convert them
      // to a list of LatLng, required by the Polyline

      results.forEach((PointLatLng points) {
        polylinesCoordinatesList.add(LatLng(points.latitude, points.longitude));
      });
    }

    _polylines.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyId'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylinesCoordinatesList,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polylines.add(polyline);
    });

    LatLngBounds bounds;

    if (pickLatLng.latitude > destLatLng.latitude &&
        pickLatLng.longitude > destLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: destLatLng,
        northeast: pickLatLng,
      );
    } else if (pickLatLng.longitude > destLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickLatLng.latitude, destLatLng.longitude),
        northeast: LatLng(destLatLng.latitude, pickLatLng.longitude),
      );
    } else if (pickLatLng.latitude > destLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destLatLng.latitude, pickLatLng.longitude),
        northeast: LatLng(pickLatLng.latitude, destLatLng.longitude),
      );
    } else {
      bounds = LatLngBounds(
        southwest: pickLatLng,
        northeast: destLatLng,
      );
    }

    tripMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickUp'),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('Destination'),
      position: destLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: BrandColors.colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destLatLng,
      fillColor: BrandColors.colorAccentPurple,
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
  }

  void getLocationUpdates() {
    LatLng oldPos = LatLng(0, 0);

    carPositionStream = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 4,
      timeInterval: 200,
    ).listen((Position position) {
      currentPosition = position;
      carPosition = position;
      LatLng pos = LatLng(position.latitude, position.longitude);

      double rotation = MapToolkitHelper.getMarkerRotation(
        oldPos.latitude,
        oldPos.longitude,
        pos.latitude,
        pos.longitude,
      );

      Marker carMarker = Marker(
        markerId: MarkerId('moving'),
        position: pos,
        icon: movingCarIcon,
        infoWindow: InfoWindow(title: 'Current Location'),
        rotation: rotation,
      );

      setState(() {
        CameraPosition cp = new CameraPosition(
          target: pos,
          zoom: 17,
        );
        tripMapController.animateCamera(CameraUpdate.newCameraPosition(cp));
        _markers.removeWhere((element) => element.markerId.value == 'moving');
        _markers.add(carMarker);
      });

      oldPos = pos;

      updateTripDetails();

      Map locationMap = {
        'latitude': carPosition.latitude,
        'longitude': carPosition.longitude,
      };

      rideRef.child('driver_location').set(locationMap);
    });
  }

  void startTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      timeCounter++;
    });
  }

  void totalEarnings(int fares) {
    DatabaseReference earningRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentUser.uid}/earnings');

    earningRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        double pastEarnings = double.parse(snapshot.value.toString());
        double totalEarnings = fares + pastEarnings;
        earningRef.set(totalEarnings.toString());
      } else {
        earningRef.set(fares.toString());
      }
    });
  }

  void updateTripDetails() async {
    if (!isdirectionRequesting) {
      isdirectionRequesting = true;

      if (carPosition == null) {
        return;
      }
      LatLng startLatLng = LatLng(carPosition.latitude, carPosition.longitude);
      LatLng destLatLng;

      if (driverStatus == 'accepted') {
        destLatLng = widget.tripDetails.pickupCoordinates;
      } else {
        destLatLng = widget.tripDetails.destinationCoordinates;
      }

      var directionDetails =
          await HelperMethods.getDirectionDetails(startLatLng, destLatLng);

      if (directionDetails != null) {
        setState(() {
          durationString = directionDetails.durationText;
        });
      }

      isdirectionRequesting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(
                bottom: 255,
              ),
              initialCameraPosition: kGooglePlex,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) async {
                _completer.complete(controller);
                tripMapController = controller;

                LatLng currentPosLatLng =
                    LatLng(currentPosition.latitude, currentPosition.longitude);
                LatLng pickupPosLatLng = widget.tripDetails.pickupCoordinates;

                await getDirection(currentPosLatLng, pickupPosLatLng);
                getLocationUpdates();
              },
              circles: _circles,
              markers: _markers,
              polylines: _polylines,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),
                height: 255,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        durationString,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Brand-Bold',
                          color: BrandColors.colorAccentPurple,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.tripDetails.riderName,
                            style: TextStyle(
                              fontFamily: 'Brand-Bold',
                              fontSize: 22,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.call,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'images/pickicon.png',
                            height: 16,
                            width: 16,
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                widget.tripDetails.pickupAddress,
                                style: TextStyle(fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'images/desticon.png',
                            height: 16,
                            width: 16,
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                widget.tripDetails.destinationAddress,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TaxiButton(
                        buttonText: buttonTitle,
                        color: buttonColor,
                        onPressed: () async {
                          if (driverStatus == 'accepted') {
                            driverStatus = 'arrived';
                            rideRef.child('status').set('arrived');

                            setState(() {
                              buttonTitle = 'START TRIP';
                              buttonColor = BrandColors.colorAccentPurple;
                            });

                            HelperMethods.showProgressDialog(context);

                            await getDirection(
                                widget.tripDetails.pickupCoordinates,
                                widget.tripDetails.destinationCoordinates);

                            Navigator.pop(context);
                          } else if (driverStatus == 'arrived') {
                            driverStatus = 'onTrip';
                            rideRef.child('status').set('on_trip');

                            setState(() {
                              buttonTitle = 'END TRIP';
                              buttonColor = Colors.red[300];
                            });

                            startTimer();
                          } else if (driverStatus == 'onTrip') {
                            endTrip();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
