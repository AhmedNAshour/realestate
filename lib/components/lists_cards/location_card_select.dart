import 'package:flutter/material.dart';
import 'package:realestate/constants.dart';
import 'package:realestate/models/location.dart';
import 'package:realestate/screens/admin/admin_addCompound_screen.dart';
import 'package:realestate/screens/admin/addResale_screen.dart';
import 'package:realestate/screens/admin/selectLocation_area.dart';
import 'package:realestate/screens/admin/selectLocation_district.dart';
import 'package:realestate/screens/shared/map.dart';

class SelectLocationCard extends StatelessWidget {
  const SelectLocationCard({
    Key key,
    @required this.location,
    this.govName,
    this.districtName,
    this.addType,
  }) : super(key: key);

  final Location location;
  final String govName;
  final String districtName;
  final String addType;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (location.type == 0) {
              Navigator.pushNamed(context, SelectDistrict.id, arguments: {
                'govName': location.docId,
                'addType': addType,
              });
            } else if (location.type == 1) {
              if (addType == 'compound') {
                Navigator.pushNamed(context, MapSelect.id, arguments: {
                  'addType': addType,
                  'govName': govName,
                  'districtName': location.docId,
                });
              } else {
                Navigator.pushNamed(context, SelectArea.id, arguments: {
                  'govName': govName,
                  'districtName': location.docId,
                  'addType': addType,
                });
              }
            } else {
              Navigator.pushNamed(context, MapSelect.id, arguments: {
                'addType': addType,
                'govName': govName,
                'districtName': districtName,
                'areaName': location.docId,
              });
              // if (addType == 'compound') {
              //   Navigator.pushNamed(context, AdminAddCompound.id, arguments: {
              //     'govName': govName,
              //     'districtName': districtName,
              //     'areaName': location.docId,
              //   });
              // } else {
              //   Navigator.pushNamed(context, AddResale.id, arguments: {
              //     'govName': govName,
              //     'districtName': districtName,
              //     'areaName': location.docId,
              //   });
              // }
            }
          },
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: Container(
                  width: screenWidth * 0.9,
                  // margin: EdgeInsets.only(bottom: size.height * 0.025),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    location.docId,
                    style: TextStyle(
                        color: kPrimaryTextColor, fontSize: size.width * 0.05),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
      ],
    );
  }
}
