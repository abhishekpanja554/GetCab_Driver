import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/data_provider.dart';
import 'package:uber_clone_driver/globalVariables.dart';
import 'package:uber_clone_driver/screens/history_page.dart';
import 'package:uber_clone_driver/widgets/brand_divider.dart';

class EarningsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: BrandColors.colorPrimary,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 70,
            ),
            child: Column(
              children: [
                Text(
                  'Total Earnings',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '₹${Provider.of<AppData>(context).earnings}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'Brand-Bold',
                  ),
                ),
              ],
            ),
          ),
        ),
        FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pushNamed(context, HistoryPage.id);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 30,
            ),
            child: Row(
              children: [
                Image.asset(
                  'images/taxi.png',
                  width: 70,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Trips',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      Provider.of<AppData>(context, listen: false)
                          .tripCount
                          .toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        BrandDivider(),
      ],
    );
  }
}
