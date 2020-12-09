import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetails {
  String pickupAddress;
  String destinationAddress;
  LatLng pickupCoordinates;
  LatLng destinationCoordinates;
  String rideId;
  String paymentMethod;
  String riderName;
  String riderPhone;

  TripDetails({
    this.destinationAddress,
    this.destinationCoordinates,
    this.paymentMethod,
    this.pickupAddress,
    this.pickupCoordinates,
    this.rideId,
    this.riderName,
    this.riderPhone,
  });
}
