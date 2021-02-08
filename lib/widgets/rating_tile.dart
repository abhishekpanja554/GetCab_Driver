import 'package:flutter/material.dart';
import 'package:uber_clone_driver/brand_colors.dart';
import 'package:uber_clone_driver/data_models/history.dart';
import 'package:uber_clone_driver/helpers/helper_methods.dart';

class RatingTile extends StatefulWidget {
  final History history;
  RatingTile({this.history});

  @override
  _RatingTileState createState() => _RatingTileState();
}

class _RatingTileState extends State<RatingTile> {
  var list = [];

  void createList() {
    for (int i = 0; i < int.parse(widget.history.rating); i++) {
      list.add(i);
    }
  }

  @override
  void initState() {
    createList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'images/pickicon.png',
                      height: 16,
                      width: 16,
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          (widget.history.pickup == null)
                              ? ''
                              : widget.history.pickup,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    list == null || list.isEmpty
                        ? Text('')
                        : Row(
                            children: [
                              for (var i in list)
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[900],
                                ),
                            ],
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset(
                    'images/desticon.png',
                    height: 16,
                    width: 16,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Text(
                    (widget.history.destination == null)
                        ? ''
                        : widget.history.destination,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                HelperMethods.dateFormatter(widget.history.createdAt),
                style: TextStyle(color: BrandColors.colorTextLight),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
