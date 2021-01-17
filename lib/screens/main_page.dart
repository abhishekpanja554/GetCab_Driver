import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/screens/tabs/earnings_tab.dart';
import 'package:uber_clone_driver/screens/tabs/home_tab.dart';
import 'package:uber_clone_driver/screens/tabs/profile_tab.dart';
import 'package:uber_clone_driver/screens/tabs/ratings_tab.dart';

class MainPage extends StatefulWidget {
  static const String id = 'mainpage';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  MotionTabController _tabController;

  int selectedTabIndex = 0;

  void onItemClicked(int index) {
    setState(() {
      selectedTabIndex = index;
      _tabController.index = selectedTabIndex;
    });
  }

  @override
  void initState() {
    _tabController = MotionTabController(
      initialIndex: 1,
      vsync: this,
      length: 4,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: [
          HomeTab(),
          EarningsTab(),
          RatingsTab(),
          ProfileTab(),
        ],
        index: selectedTabIndex,
      ),
      bottomNavigationBar: MotionTabBar(
        labels: ["Home", "Earnings", "Ratings", "Profile"],
        initialSelectedTab: "Home",
        tabIconColor: Color(0xFF3F424B),
        tabSelectedColor: BrandColors.colorGreen,
        onTabItemSelected: onItemClicked,
        icons: [Icons.home, Icons.credit_card, Icons.star, Icons.person],
        textStyle: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
