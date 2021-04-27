import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:realestate/components/propertyImages-carousel.dart';
import 'package:realestate/models/compound.dart';
import 'package:realestate/constants.dart';
import 'package:realestate/models/user.dart';
import 'package:realestate/services/database.dart';

class CompoundInfo extends StatefulWidget {
  static const id = 'CompoundInfo';

  @override
  _CompoundInfoState createState() => _CompoundInfoState();
}

class _CompoundInfoState extends State<CompoundInfo> {
  Map compoundAndUserData = {};
  int selectedTab = 0;
  String dateSearch = '';
  var dateTextController = new TextEditingController();

  changeDateSearch(newDate) {
    setState(() {
      dateSearch = newDate;
    });
  }

  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    compoundAndUserData = ModalRoute.of(context).settings.arguments;
    Compound compound = compoundAndUserData['compound'];
    UserData userData = compoundAndUserData['user'];

    return Scaffold(
      body: Stack(
        children: [
          PropertyImages(
            images: compound.images,
          ),
          Positioned(
            top: height * 0.05,
            left: width * 0.05,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3000),
              child: Container(
                color: kPrimaryLightColor,
                height: height * 0.05,
                width: height * 0.05,
                child: BackButton(
                  color: kSecondaryColor,
                ),
              ),
            ),
          ),
          userData != null && userData.role == 'admin'
              ? Positioned(
                  top: height * 0.05,
                  right: width * 0.05,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3000),
                    child: GestureDetector(
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.WARNING,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Deactivate Compound',
                          desc:
                              'Are your sure you want to deactivate this compound ?',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async {
                            await DatabaseService().updatePropertyStatus(
                                propertyID: compound.uid, status: 'inactive');
                          },
                        )..show();
                      },
                      child: Container(
                        color: kPrimaryLightColor,
                        height: height * 0.05,
                        width: height * 0.05,
                        child: Icon(
                          FontAwesomeIcons.trash,
                          color: kSecondaryColor,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              height: size.height * 0.65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(53),
                    topRight: Radius.circular(53)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   '${compound.meterPrice} EGP/sqm',
                    //   style: TextStyle(
                    //     color: kSecondaryColor,
                    //     fontSize: height * 0.025,
                    //   ),
                    // ),
                    Text(
                      '${compound.name}',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: height * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${compound.locationLevel2} , ${compound.locationLevel1}',
                      style: TextStyle(
                        color: kPrimaryLightTextColor,
                        fontSize: size.height * 0.025,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    // SizedBox(
                    //   height: height * 0.02,
                    // ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: height * 0.02),
                      height: height * 0.0001,
                      color: kPrimaryTextColor,
                    ),
                    Text(
                      'Price/Meter square',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      '${compound.meterPrice} EGP/sqm',
                      style: TextStyle(
                        color: kPrimaryLightTextColor,
                        fontSize: size.height * 0.025,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: height * 0.02),
                      height: height * 0.0001,
                      color: kPrimaryTextColor,
                    ),
                    Text(
                      'Delivery date',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      '${compound.deliveryDate}',
                      style: TextStyle(
                        color: kPrimaryLightTextColor,
                        fontSize: size.height * 0.025,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: height * 0.02),
                      height: height * 0.0001,
                      color: kPrimaryTextColor,
                    ),
                    Text(
                      'Installement years',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      '${compound.paymentPlan}',
                      style: TextStyle(
                        color: kPrimaryLightTextColor,
                        fontSize: size.height * 0.025,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: height * 0.02),
                      height: height * 0.0001,
                      color: kPrimaryTextColor,
                    ),
                    Text(
                      'Description',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),

                    Container(
                      // height: height * 0.15,
                      child: SingleChildScrollView(
                        child: Text(
                          compound.description,
                          style: TextStyle(
                            color: kPrimaryLightTextColor,
                            fontSize: size.height * 0.025,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
