import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/data_provider.dart';
import 'package:uber_clone_driver/helpers/helper_methods.dart';
import 'package:uber_clone_driver/screens/history_page.dart';
import 'package:uber_clone_driver/widgets/taxi_button.dart';

class EarningsTab extends StatefulWidget {
  @override
  _EarningsTabState createState() => _EarningsTabState();
}

class _EarningsTabState extends State<EarningsTab> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return RefreshIndicator(
      backgroundColor: Color(0xFF6ACE7A),
      displacement: 80,
      color: Color(0xFF293453),
      key: _refreshIndicatorKey,
      onRefresh: () async {
        HelperMethods.getHistory(context);
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
                    'Earnings',
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
                bottom: (mediaQuery.size.height - 450),
                left: 20,
                right: 20,
                child: Container(
                  width: (mediaQuery.size.width - 40),
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.asset('images/rupee-background.png').image,
                      fit: BoxFit.fill,
                    ),
                    color: Colors.red,
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'TOTAL EARNINGS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Brand-Regular',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '₹${Provider.of<AppData>(context).earnings ?? '0'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Brand-Bold',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: (mediaQuery.size.height - 670),
                left: 20,
                right: 20,
                child: Container(
                  width: (mediaQuery.size.width - 40),
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.asset('images/car-background.png').image,
                      fit: BoxFit.fill,
                    ),
                    color: Colors.red,
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'TOTAL RIDES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Brand-Regular',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        Provider.of<AppData>(context).tripCount.toString() ??
                            '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Brand-Bold',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: (mediaQuery.size.height - 740),
                right: 20,
                child: TaxiButton(
                  buttonText: 'View History',
                  color: BrandColors.colorGreen,
                  onPressed: () {
                    Navigator.pushNamed(context, HistoryPage.id);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
