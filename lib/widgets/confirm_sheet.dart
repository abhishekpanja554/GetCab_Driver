import 'package:flutter/material.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/widgets/TaxiOutlineButton.dart';
import 'package:uber_clone_driver/widgets/taxi_button.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function onPressed;

  const ConfirmSheet({
    this.title,
    this.subTitle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            spreadRadius: 0.5,
            offset: Offset(
              0.5,
              0.5,
            ),
          ),
        ],
      ),
      height: 220,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Brand-Bold',
                color: BrandColors.colorText,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: BrandColors.colorTextLight,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: TaxiOutlineButton(
                      title: 'BACK',
                      color: BrandColors.colorLightGrayFair,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    child: TaxiButton(
                      buttonText: 'CONFIRM',
                      color: (title == 'GO ONLINE')
                          ? BrandColors.colorGreen
                          : Colors.red,
                      onPressed: onPressed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
