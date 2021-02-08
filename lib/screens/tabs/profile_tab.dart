import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/globalVariables.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/data_provider.dart';
import 'package:uber_clone_driver/helpers/helper_methods.dart';
import 'package:uber_clone_driver/screens/profile_edit_page.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Color carDetailTileColor = Colors.grey[750];
  IconData carDetailTileIcon = Icons.expand_more;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        backgroundColor: Color(0xFF6ACE7A),
        displacement: 80,
        color: Color(0xFF293453),
        onRefresh: () async {
          setState(() {
            HelperMethods.getLatestDriverInfo(context);
          });

          await Future.delayed(Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            color: Color(0xFF3F424B),
            height: mediaQuery.size.height - 65,
            width: mediaQuery.size.width,
            child: Stack(
              children: [
                Positioned(
                  bottom: (mediaQuery.size.height - 190),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontFamily: 'Brand-Regular',
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: (mediaQuery.size.height - 200),
                    width: mediaQuery.size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  top: mediaQuery.size.height - (mediaQuery.size.height - 160),
                  child: Column(
                    children: [
                      ExpandableNotifier(
                        child: Expandable(
                          collapsed: ExpandableButton(
                            child: Container(
                              alignment: Alignment.center,
                              width: (mediaQuery.size.width - 40),
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: Image.asset(
                                          'images/small-profile-background.png')
                                      .image,
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(
                                      0.7,
                                      0.7,
                                    ),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Personal Information',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Brand-Regular',
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                          expanded: ExpandableButton(
                            child: Container(
                              width: (mediaQuery.size.width - 40),
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: Image.asset(
                                          'images/profile-background.png')
                                      .image,
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(
                                      0.7,
                                      0.7,
                                    ),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      currentDriverInfo.fullName ?? 'Driver',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      currentDriverInfo.email ?? 'email',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      currentDriverInfo.phone ?? 'phone',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ExpandableNotifier(
                        child: Expandable(
                          collapsed: ExpandableButton(
                            child: Container(
                              alignment: Alignment.center,
                              width: (mediaQuery.size.width - 40),
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      Image.asset('images/car-background2.png')
                                          .image,
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(
                                      0.7,
                                      0.7,
                                    ),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Car Information',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Brand-Regular',
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                          expanded: ExpandableButton(
                            child: Container(
                              width: (mediaQuery.size.width - 40),
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: Image.asset(
                                          'images/big-car-background2.png')
                                      .image,
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(
                                      0.7,
                                      0.7,
                                    ),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.directions_car,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      currentDriverInfo.carModel ?? 'Model',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    trailing: Text(
                                      'Car Model',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.color_lens,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      currentDriverInfo.carColor ?? 'Color',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    trailing: Text(
                                      'Colour',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.format_list_bulleted,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      currentDriverInfo.vehicleNumber ??
                                          'number',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    trailing: Text(
                                      'Regd Number',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AnimatedContainer(
                        curve: Curves.easeOutExpo,
                        duration: Duration(
                          milliseconds: 500,
                        ),
                        margin: Provider.of<AppData>(context, listen: false)
                                .editButtonVisible
                            ? EdgeInsets.only(left: 0)
                            : EdgeInsets.only(left: 200),
                        alignment: Alignment.center,
                        height: 60,
                        width: 147,
                        decoration: BoxDecoration(
                          color: BrandColors.colorGreen,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            var response = await Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return ProfileEditPage(
                                ancestorContext: _scaffoldKey.currentContext,
                              );
                            }));

                            if (response == 'close') {
                              _refreshIndicatorKey.currentState.show();
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                backgroundColor: Color(0xFF293453),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Brand-Regular',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
