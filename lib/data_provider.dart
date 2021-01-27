import 'package:flutter/cupertino.dart';
import 'package:uber_clone_driver/data_models/history.dart';

class AppData extends ChangeNotifier {
  String earnings = '0';
  int tripCount = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistory = [];
  bool editButtonVisible = true;

  void updateVisibility( bool newState){
    editButtonVisible = newState;
    notifyListeners();
  }

  void updateEarnings(String newEarning) {
    earnings = newEarning;
    notifyListeners();
  }

  void updateTripCount(int newTripCount) {
    tripCount = newTripCount;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistory(History historyItem) {
    if (historyItem == null) {
      tripHistory = [];
    } else {
      tripHistory.add(historyItem);
    }
    notifyListeners();
  }
}
