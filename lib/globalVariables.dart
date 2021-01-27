import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'data_models/driver.dart';

User currentUser;

final CameraPosition kGooglePlex = CameraPosition(
  target: LatLng(24, 67),
  zoom: 14.4746,
);

String apiKey = "AIzaSyDu3LOP9fTpiL-Vaa6YECeNDJNb8FFEhqw";
DatabaseReference tripRequestRef;
StreamSubscription<Position> positionStream;
StreamSubscription<Position> carPositionStream;
final assetAudioPlayer = AssetsAudioPlayer();
Position currentPosition;
DatabaseReference rideRef;
Driver currentDriverInfo;
int totalEarning = 0;