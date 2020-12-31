import 'package:flutter/material.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/helpers/helper_methods.dart';
import 'package:uber_clone_driver/widgets/brand_divider.dart';
import 'package:uber_clone_driver/widgets/taxi_button.dart';

class PaymentDialog extends StatelessWidget {
  final String paymentMethod;
  final int fare;

  PaymentDialog({this.fare, this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Text('${paymentMethod.toUpperCase()} PAYMENT'),
            SizedBox(
              height: 20,
            ),
            BrandDivider(),
            SizedBox(
              height: 16.0,
            ),
            Text(
              '₹$fare',
              style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 50),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Amount above is the total fares to be charged to the rider',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 230,
              child: TaxiButton(
                buttonText: 'COLLECT CASH',
                color: BrandColors.colorGreen,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  HelperMethods.enableLocationSubscription();
                },
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
