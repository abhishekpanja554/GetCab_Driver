import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/data_provider.dart';
import 'package:uber_clone_driver/helpers/helper_methods.dart';
import 'package:uber_clone_driver/widgets/brand_divider.dart';
import 'package:uber_clone_driver/widgets/rating_tile.dart';

class RatingsTab extends StatelessWidget {
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
                    'Ratings',
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
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: (Provider.of<AppData>(context, listen: false)
                                  .tripHistory
                                  .length <=
                              0 ||
                          Provider.of<AppData>(context, listen: false)
                                  .tripHistory[0] ==
                              null)
                      ? Center(
                          child: Text(
                            'You have no ride history',
                            style: TextStyle(
                              fontFamily: 'Brand-Bold',
                              fontSize: 16,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.separated(
                                padding: EdgeInsets.all(0),
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Card(
                                    elevation: 3,
                                    child: RatingTile(
                                      history: Provider.of<AppData>(context,
                                              listen: false)
                                          .tripHistory[index],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        BrandDivider(),
                                itemCount: Provider.of<AppData>(context)
                                    .tripHistory
                                    .length,
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              // Positioned(
              //   bottom: (mediaQuery.size.height - 450),
              //   left: 20,
              //   right: 20,
              //   child: Container(
              //     width: (mediaQuery.size.width - 40),
              //     height: 200,
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: Image.asset('images/rupee-background.png').image,
              //         fit: BoxFit.fill,
              //       ),
              //       color: Colors.red,
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(15),
              //       ),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black12,
              //           blurRadius: 2,
              //           spreadRadius: 2,
              //           offset: Offset(
              //             0.7,
              //             0.7,
              //           ),
              //         ),
              //       ],
              //     ),
              //     child: Column(
              //       children: [
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text(
              //           'TOTAL EARNINGS',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 30,
              //             fontFamily: 'Brand-Regular',
              //           ),
              //         ),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text(
              //           'blah',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 50,
              //             fontFamily: 'Brand-Bold',
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Positioned(
              //   bottom: (mediaQuery.size.height - 670),
              //   left: 20,
              //   right: 20,
              //   child: Container(
              //     width: (mediaQuery.size.width - 40),
              //     height: 200,
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: Image.asset('images/car-background.png').image,
              //         fit: BoxFit.fill,
              //       ),
              //       color: Colors.red,
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(15),
              //       ),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black12,
              //           blurRadius: 2,
              //           spreadRadius: 2,
              //           offset: Offset(
              //             0.7,
              //             0.7,
              //           ),
              //         ),
              //       ],
              //     ),
              //     child: Column(
              //       children: [
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text(
              //           'TOTAL RIDES',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 30,
              //             fontFamily: 'Brand-Regular',
              //           ),
              //         ),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text(
              //           Provider.of<AppData>(context).tripCount.toString() ??
              //               '0',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 50,
              //             fontFamily: 'Brand-Bold',
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Positioned(
              //   bottom: (mediaQuery.size.height - 740),
              //   right: 20,
              //   child: TaxiButton(
              //     buttonText: 'View History',
              //     color: BrandColors.colorGreen,
              //     onPressed: () {
              //       Navigator.pushNamed(context, HistoryPage.id);
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
