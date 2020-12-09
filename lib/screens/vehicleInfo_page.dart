import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/globalVariables.dart';
import 'package:uber_clone_driver/screens/main_page.dart';
import 'package:uber_clone_driver/widgets/taxi_button.dart';

class VehicleInfoPage extends StatelessWidget {
  static const String id = 'vehicleInfoPage';

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackBar = SnackBar(
      content: Text(
        title,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  TextEditingController carModelController = TextEditingController();
  TextEditingController carColorController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();

  void updateProfile(context) {
    String uid = currentUser.uid;
    DatabaseReference dbRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/$uid/vehicle_details');

    Map vehicleDetails = {
      'car_model': carModelController.text,
      'car_color': carColorController.text,
      'vehicle_number': vehicleNumberController.text,
    };

    dbRef.set(vehicleDetails);

    Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'images/logo.png',
                height: 110,
                width: 110,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Enter Vehicle Details',
                      style: TextStyle(
                        fontFamily: 'Brand-Bold',
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: carModelController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Car Model',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: carColorController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Car Color',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: vehicleNumberController,
                      maxLength: 11,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Number',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TaxiButton(
                      buttonText: 'PROCEED',
                      color: BrandColors.colorGreen,
                      onPressed: () {
                        RegExp exp =
                            RegExp(r"^[a-z]{2}[0-9]{2}[a-z]{1,2}[0-9]{4}$");

                        if (carModelController.text.length < 3) {
                          showSnackBar('Please provide a valid car Model');
                          return;
                        }

                        if (carColorController.text.length < 3) {
                          showSnackBar('Please provide a valid color');
                          return;
                        }

                        if (vehicleNumberController.text.length < 3 ||
                            exp.hasMatch(vehicleNumberController.text)) {
                          showSnackBar('Please provide a valid vehicle number');
                          return;
                        }

                        updateProfile(context);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
