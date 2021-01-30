import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/globalVariables.dart';
import 'package:uber_clone_driver/helpers/helper_methods.dart';
import 'package:uber_clone_driver/widgets/taxi_button.dart';

class ProfileEditPage extends StatefulWidget {
  static const String id = 'profileeditpage';

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController carModelController = TextEditingController();
  TextEditingController carColorController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();

  void updateProfile(context) {
    String uid = currentUser.uid;
    DatabaseReference dbRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/$uid/vehicle_details');
    DatabaseReference dbPersonRef =
        FirebaseDatabase.instance.reference().child('drivers/$uid');

    Map vehicleDetails = {
      'car_model': carModelController.text,
      'car_color': carColorController.text,
      'vehicle_number': vehicleNumberController.text,
    };
    dbPersonRef.child('fullname').set(fullnameController.text);
    dbPersonRef.child('email').set(emailController.text);
    dbPersonRef.child('phone').set(phoneController.text);

    dbRef.set(vehicleDetails);

    HelperMethods.getLatestDriverInfo();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3F424B),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Edit Profile',
            ),
            Icon(
              Icons.person,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'images/user_icon.png',
                height: 70,
                width: 70,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                child: Column(
                  children: [
                    TextField(
                      controller: fullnameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Fullname',
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
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
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
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone',
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
                      buttonText: 'UPDATE',
                      color: BrandColors.colorGreen,
                      onPressed: () {
                        RegExp exp =
                            RegExp(r"^[a-z]{2}[0-9]{2}[a-z]{1,2}[0-9]{4}$");

                        if (fullnameController.text.length < 3) {
                          Toast.show(
                            "Please provide a valid Fullname",
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM,
                          );

                          return;
                        }

                        if (emailController.text.length < 3) {
                          Toast.show(
                            "Please provide a valid Email",
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM,
                          );
                          return;
                        }

                        if (phoneController.text.length < 10) {
                          Toast.show(
                            "Please provide a valid phone number",
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM,
                          );
                          return;
                        }
                        if (carModelController.text.length < 3) {
                          Toast.show(
                            "Please provide a valid car model",
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM,
                          );
                          return;
                        }

                        if (carColorController.text.length < 3) {
                          Toast.show(
                            "Please provide a valid car color",
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM,
                          );
                          return;
                        }

                        if (vehicleNumberController.text.length < 3 ||
                            exp.hasMatch(vehicleNumberController.text)) {
                          Toast.show(
                            "Please provide a valid vehicle number",
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM,
                          );
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
