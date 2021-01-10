import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/data_provider.dart';
import 'package:uber_clone_driver/widgets/HistoryTile.dart';
import 'package:uber_clone_driver/widgets/brand_divider.dart';

class HistoryPage extends StatefulWidget {
  static const String id = 'HistoryPage';
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.colorPrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trip History',
            ),
            Icon(
              Icons.history,
            ),
          ],
        ),
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(0),
        itemBuilder: (BuildContext context, int index) {
          return HistoryTile(
            history: Provider.of<AppData>(context).tripHistory[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) => BrandDivider(),
        itemCount: Provider.of<AppData>(context).tripHistory.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}