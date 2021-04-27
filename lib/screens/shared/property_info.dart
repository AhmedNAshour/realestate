import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:realestate/components/dateSelection_ModalBottomSheet.dart';
import 'package:realestate/components/lists_cards/user_card.dart';
import 'package:realestate/components/loginSingupModalBottomSheet.dart';
import 'package:realestate/components/propertyImages-carousel.dart';
import 'package:realestate/models/property.dart';
import 'package:realestate/constants.dart';
import 'package:realestate/models/user.dart';
import 'package:realestate/screens/shared/loading.dart';
import 'package:realestate/services/database.dart';

class PropertyInfo extends StatefulWidget {
  static const id = 'PropertyInfo';

  @override
  _PropertyInfoState createState() => _PropertyInfoState();
}

class _PropertyInfoState extends State<PropertyInfo> {
  Property property;
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
    final user = Provider.of<MyUser>(context);

    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    property = ModalRoute.of(context).settings.arguments;

    return user != null
        ? StreamBuilder<UserData>(
            stream: DatabaseService(uid: user.uid).userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData userData = snapshot.data;
                isLiked = userData.likes.contains(property.uid);
                return Scaffold(
                  body: Stack(
                    children: [
                      PropertyImages(
                        images: property.images,
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
                      Positioned(
                        top: height * 0.05,
                        right: width * 0.05,
                        child: userData.role != 'admin'
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(3000),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (isLiked) {
                                      userData.likes.remove(property.uid);
                                      await DatabaseService(uid: user.uid)
                                          .updateUserLikes(userData.likes);
                                    } else {
                                      userData.likes.add(property.uid);
                                      await DatabaseService(uid: user.uid)
                                          .updateUserLikes(userData.likes);
                                    }
                                  },
                                  child: Container(
                                    color: kPrimaryLightColor,
                                    height: height * 0.05,
                                    width: height * 0.05,
                                    child: Icon(
                                      isLiked
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.heart,
                                      color: kSecondaryColor,
                                    ),
                                  ),
                                ),
                              )
                            : property.status != 'pending'
                                ? Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(3000),
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (isLiked) {
                                              userData.likes
                                                  .remove(property.uid);
                                              await DatabaseService(
                                                      uid: user.uid)
                                                  .updateUserLikes(
                                                      userData.likes);
                                            } else {
                                              userData.likes.add(property.uid);
                                              await DatabaseService(
                                                      uid: user.uid)
                                                  .updateUserLikes(
                                                      userData.likes);
                                            }
                                          },
                                          child: Container(
                                            color: kPrimaryLightColor,
                                            height: height * 0.05,
                                            width: height * 0.05,
                                            child: Icon(
                                              isLiked
                                                  ? FontAwesomeIcons.solidHeart
                                                  : FontAwesomeIcons.heart,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.04),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(3000),
                                        child: GestureDetector(
                                          onTap: () {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.WARNING,
                                              animType: AnimType.BOTTOMSLIDE,
                                              title: 'Deactivate Property',
                                              desc:
                                                  'Are your sure you want to deactivate this property ?',
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () async {
                                                await DatabaseService()
                                                    .updatePropertyStatus(
                                                        propertyID:
                                                            property.uid,
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
                                  )
                                : Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(3000),
                                        child: GestureDetector(
                                          onTap: () {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.WARNING,
                                              animType: AnimType.BOTTOMSLIDE,
                                              title: 'Deny Request',
                                              desc:
                                                  'Are your sure you want to deny this request ?',
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () async {
                                                await DatabaseService()
                                                    .updatePropertyStatus(
                                                        propertyID:
                                                            property.uid,
                                                        status: 'denied');
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
                                      SizedBox(width: width * 0.04),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(3000),
                                        child: GestureDetector(
                                          onTap: () {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.WARNING,
                                              animType: AnimType.BOTTOMSLIDE,
                                              title: 'Accept Request',
                                              desc:
                                                  'Are your sure you want to accept this request ?',
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () async {
                                                await DatabaseService()
                                                    .updatePropertyStatus(
                                                        propertyID:
                                                            property.uid,
                                                        status: 'active');
                                              },
                                            )..show();
                                          },
                                          child: Container(
                                            color: kPrimaryLightColor,
                                            height: height * 0.05,
                                            width: height * 0.05,
                                            child: Icon(
                                              FontAwesomeIcons.check,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 30),
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
                                Text(
                                  property.propertyType,
                                  style: TextStyle(
                                    color: kSecondaryColor,
                                    fontSize: height * 0.025,
                                  ),
                                ),
                                property.listingType == 1
                                    ? Text(
                                        '${property.price} EGP',
                                        style: TextStyle(
                                          color: kPrimaryTextColor,
                                          fontSize: height * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: kPrimaryTextColor,
                                            fontSize: height * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '${property.price} EGP'),
                                            TextSpan(
                                              text: '/Month',
                                              style: TextStyle(
                                                color: kPrimaryLightTextColor,
                                                fontSize: height * 0.04,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                Text(
                                  '${property.area} , ${property.district} , ${property.governate}',
                                  style: TextStyle(
                                    color: kPrimaryLightTextColor,
                                    fontSize: height * 0.03,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.bed,
                                      size: width * 0.06,
                                      color: kPrimaryLightTextColor,
                                    ),
                                    SizedBox(
                                      width: width * 0.04,
                                    ),
                                    Text(
                                      '${property.numBedrooms}',
                                      style: TextStyle(
                                        color: kPrimaryTextColor,
                                        // fontSize: height * 0.03,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.08,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.bath,
                                      size: width * 0.06,
                                      color: kPrimaryLightTextColor,
                                    ),
                                    SizedBox(
                                      width: width * 0.04,
                                    ),
                                    Text(
                                      '${property.numBathrooms}',
                                      style: TextStyle(
                                        color: kPrimaryTextColor,
                                        // fontSize: height * 0.03,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.08,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.ruler,
                                      size: width * 0.06,
                                      color: kPrimaryLightTextColor,
                                    ),
                                    SizedBox(
                                      width: width * 0.04,
                                    ),
                                    Text(
                                      '${property.size} sqm',
                                      style: TextStyle(
                                        color: kPrimaryTextColor,
                                        // fontSize: height * 0.03,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: height * 0.02),
                                  height: height * 0.0001,
                                  color: kPrimaryTextColor,
                                ),
                                userData.role == 'admin' ||
                                        userData.role == 'salesman'
                                    ? Text(
                                        'Listing Agent',
                                        style: TextStyle(
                                          color: kPrimaryTextColor,
                                          fontSize: size.height * 0.03,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Container(),
                                userData.role == 'admin' ||
                                        userData.role == 'salesman'
                                    ? SizedBox(
                                        height: height * 0.01,
                                      )
                                    : Container(),
                                userData.role == 'admin' ||
                                        userData.role == 'salesman'
                                    //TODO: Insert user
                                    ? UserCard(user: property.agent)
                                    : Container(),
                                userData.role == 'admin' ||
                                        userData.role == 'salesman'
                                    ? SizedBox(
                                        height: height * 0.02,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: userData.role == 'admin' ||
                          userData.role == 'salesman'
                      ? null
                      : RawMaterialButton(
                          onPressed: () async {
                            if (user != null) {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0)),
                                ),
                                builder: (context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter insideState) {
                                    return DateSelectionForm(
                                      changeDateSearch: changeDateSearch,
                                      dateTextController: dateTextController,
                                      dateSearch: dateSearch,
                                      property: property,
                                      user: userData,
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
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter insideState) {
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
                        ),
                );
              } else {
                return Loading();
              }
            })
        : Scaffold(
            body: Stack(
              children: [
                PropertyImages(
                  images: property.images,
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
                Positioned(
                  top: height * 0.05,
                  right: width * 0.05,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3000),
                    child: GestureDetector(
                      onTap: () {
                        if (user != null) {
                        } else {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0)),
                            ),
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.9,
                                child: DraggableScrollableSheet(
                                  initialChildSize: 1.0,
                                  maxChildSize: 1.0,
                                  minChildSize: 0.25,
                                  builder: (BuildContext context,
                                      ScrollController scrollController) {
                                    return StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter insideState) {
                                      return LoginSignupModalBottomSheet(
                                        modalBottomSheetState: insideState,
                                      );
                                    });
                                  },
                                ),
                              );
                            },
                            isScrollControlled: true,
                          );
                        }
                      },
                      child: Container(
                        color: kPrimaryLightColor,
                        height: height * 0.05,
                        width: height * 0.05,
                        child: Icon(
                          FontAwesomeIcons.heart,
                          color: kSecondaryColor,
                        ),
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
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(53),
                          topRight: Radius.circular(53)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property.propertyType,
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: height * 0.025,
                            ),
                          ),
                          property.listingType == 1
                              ? Text(
                                  '${property.price} EGP',
                                  style: TextStyle(
                                    color: kPrimaryTextColor,
                                    fontSize: height * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: kPrimaryTextColor,
                                      fontSize: height * 0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(text: '${property.price} EGP'),
                                      TextSpan(
                                        text: '/Month',
                                        style: TextStyle(
                                          color: kPrimaryLightTextColor,
                                          fontSize: height * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                          Text(
                            '${property.area} , ${property.district} , ${property.governate}',
                            style: TextStyle(
                              color: kPrimaryLightTextColor,
                              fontSize: height * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                FontAwesomeIcons.bed,
                                size: width * 0.06,
                                color: kPrimaryLightTextColor,
                              ),
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Text(
                                '${property.numBedrooms}',
                                style: TextStyle(
                                  color: kPrimaryTextColor,
                                  // fontSize: height * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: width * 0.08,
                              ),
                              Icon(
                                FontAwesomeIcons.bath,
                                size: width * 0.06,
                                color: kPrimaryLightTextColor,
                              ),
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Text(
                                '${property.numBathrooms}',
                                style: TextStyle(
                                  color: kPrimaryTextColor,
                                  // fontSize: height * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: width * 0.08,
                              ),
                              Icon(
                                FontAwesomeIcons.ruler,
                                size: width * 0.06,
                                color: kPrimaryLightTextColor,
                              ),
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Text(
                                '${property.size} sqm',
                                style: TextStyle(
                                  color: kPrimaryTextColor,
                                  // fontSize: height * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: height * 0.02),
                            height: height * 0.0001,
                            color: kPrimaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: RawMaterialButton(
              onPressed: () {
                if (user != null) {
                } else {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                    ),
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter insideState) {
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
            ),
          );
  }
}
