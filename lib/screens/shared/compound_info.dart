import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:realestate/components/dateSelection_ModalBottomSheet.dart';
import 'package:realestate/components/loginSingupModalBottomSheet.dart';
import 'package:realestate/components/propertyImages-carousel.dart';
import 'package:realestate/models/compound.dart';
import 'package:realestate/constants.dart';
import 'package:realestate/models/user.dart';
import 'package:realestate/services/database.dart';
import 'openMap.dart';

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

  Map amenities = {
    'Balcony': FontAwesomeIcons.check,
    'Built in Kitchen Appliances': FontAwesomeIcons.utensils,
    'Security': FontAwesomeIcons.userShield,
    'Covered Parking': FontAwesomeIcons.parking,
    'Maids Room': FontAwesomeIcons.solidUser,
    'Pets Allowed': FontAwesomeIcons.cat,
    'Pool': FontAwesomeIcons.swimmingPool,
    'Electricity Meter': FontAwesomeIcons.lightbulb,
    'Water Meter': FontAwesomeIcons.water,
    'Natural Gas': FontAwesomeIcons.gasPump,
    'Landline': FontAwesomeIcons.phone,
    'Elevator': FontAwesomeIcons.arrowUp,
    'Private Garden': FontAwesomeIcons.leaf,
  };

  Widget showBookingButton(
      UserData user, double width, double height, Compound compound) {
    if (user == null || user.role == 'client') {
      return RawMaterialButton(
        onPressed: () {
          if (user != null) {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter insideState) {
                  return DateSelectionForm(
                    changeDateSearch: changeDateSearch,
                    dateTextController: dateTextController,
                    dateSearch: dateSearch,
                    compound: compound,
                    user: user,
                  );
                });
              },
              isScrollControlled: true,
            );
          } else {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter insideState) {
                  return LoginSignupModalBottomSheet(
                    modalBottomSheetState: insideState,
                  );
                });
              },
              isScrollControlled: true,
            );
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            height: height * 0.06,
            width: width * 0.3,
            color: kPrimaryColor,
            child: Center(
              child: Text(
                'BOOK',
                style: TextStyle(
                  color: kPrimaryLightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.05,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

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
              top: height * 0.20,
              left: width * 0.06,
              child: CircleAvatar(
                radius: size.width * 0.12,
                backgroundImage: compound.logoURL != null
                    ? NetworkImage(
                        compound.logoURL,
                      )
                    : AssetImage(
                        'assets/images/userPlaceholder.png',
                      ),
              ),
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
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3000),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.pushNamed(context, MapOpen.id,
                                  arguments: {
                                    'lat': compound.latitude,
                                    'long': compound.longitude,
                                  });
                            },
                            child: Container(
                              color: kPrimaryLightColor,
                              height: height * 0.05,
                              width: height * 0.05,
                              child: Icon(
                                FontAwesomeIcons.mapMarkedAlt,
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        ClipRRect(
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
                                      propertyID: compound.uid,
                                      status: 'inactive');
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
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(3000),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(context, MapOpen.id, arguments: {
                          'lat': compound.latitude,
                          'long': compound.longitude,
                        });
                      },
                      child: Container(
                        color: kPrimaryLightColor,
                        height: height * 0.05,
                        width: height * 0.05,
                        child: Icon(
                          FontAwesomeIcons.mapMarkedAlt,
                          color: kSecondaryColor,
                        ),
                      ),
                    ),
                  ),
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
                        'Facilities',
                        style: TextStyle(
                          color: kPrimaryTextColor,
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: size.height * 0.14,
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                size.height * 1.6 / size.width * 1.4,
                          ),
                          itemCount: compound.facilities.length,
                          itemBuilder: (context, index) {
                            return compound.facilities.isNotEmpty
                                ? Row(
                                    children: [
                                      Icon(amenities[
                                          compound.facilities[index]]),
                                      SizedBox(width: size.width * 0.02),
                                      Text(
                                        compound.facilities[index],
                                        style: TextStyle(
                                          color: kPrimaryTextColor,
                                          fontSize: size.height * 0.02,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container();
                          },
                        ),
                      ),
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
                        'Payment plan',
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
                        'Finishing',
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
                        '${compound.finishingType}',
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            showBookingButton(userData, width, height, compound));
  }
}
