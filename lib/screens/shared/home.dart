import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:realestate/components/AdminHome/compoundsDistrictsSlider.dart';
import 'package:realestate/components/AdminHome/propertyTypesSlider.dart';
import 'package:realestate/components/lists_cards/compound_card.dart';
import 'package:realestate/components/lists_cards/compoundsList.dart';
import 'package:realestate/components/lists_cards/propertiesList.dart';
import 'package:realestate/components/lists_cards/propertiesList_admin.dart';
import 'package:realestate/components/loginSingupModalBottomSheet.dart';
import 'package:realestate/constants.dart';
import 'package:realestate/models/compound.dart';
import 'package:realestate/models/property.dart';
import 'package:realestate/models/user.dart';
import 'package:realestate/screens/admin/selectLocation_governate.dart';
import 'package:realestate/screens/shared/compounds_search.dart';
import 'package:realestate/screens/shared/properties_search.dart';
import 'package:realestate/services/auth.dart';
import 'package:realestate/services/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    var userData;
    try {
      userData = Provider.of<UserData>(context);
    } catch (e) {}

    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0xFFF0F0F0),
        body: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    if (user != null) {
                      await AuthService().signOut();
                    } else {
                      showModalBottomSheet(
                        isScrollControlled: true,
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
                      );
                    }
                  },
                  child: Text(
                    user == null ? 'Login' : 'Sign out',
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: size.height * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                FutureBuilder(
                  future: DatabaseService().getCompound(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CompoundCard(
                        compound: snapshot.data,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Compounds',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pushNamed(context, CompoundsSearch.id,
                            arguments: {
                              'listingType': 1,
                            });
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: size.height * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                CompoundsDistrictsSlider(),
                // Container(
                //   height: height * 0.3,
                //   child: MultiProvider(
                //     providers: [
                //       StreamProvider<List<Compound>>.value(
                //         value: DatabaseService().getCompoundsBySearch(
                //           limited: true,
                //         ),
                //       ),
                //     ],
                //     child: CompoundsList('', Axis.horizontal),
                //   ),
                // ),
                // SizedBox(height: height * 0.01),
                Text(
                  'Categories',
                  style: TextStyle(
                    color: kPrimaryTextColor,
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PropertyTypesSlider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Properties for sale',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pushNamed(context, PropertiesSearch.id,
                            arguments: {
                              'listingType': 1,
                            });
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: size.height * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Container(
                  height: height * 0.3,
                  child: MultiProvider(
                    providers: [
                      StreamProvider<List<Property>>.value(
                        value: DatabaseService().getPropertiesBySearch(
                            limited: true, listingType: 1, status: 'active'),
                      ),
                    ],
                    child: userData != null
                        ? userData.role == 'admin'
                            ? PropertiesListAdmin('', Axis.horizontal)
                            : PropertiesList('', Axis.horizontal)
                        : PropertiesList('', Axis.horizontal),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Properties for rent',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pushNamed(context, PropertiesSearch.id,
                            arguments: {
                              'listingType': 0,
                            });
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: size.height * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Container(
                  height: height * 0.3,
                  child: MultiProvider(
                    providers: [
                      StreamProvider<List<Property>>.value(
                        value: DatabaseService().getPropertiesBySearch(
                            limited: true, listingType: 0, status: 'active'),
                      ),
                    ],
                    child: userData != null
                        ? userData.role == 'admin'
                            ? PropertiesListAdmin('', Axis.horizontal)
                            : PropertiesList('', Axis.horizontal)
                        : PropertiesList('', Axis.horizontal),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: kSecondaryColor,
          onPressed: () {
            if (user != null) {
              Navigator.pushNamed(context, SelectGovernate.id, arguments: {
                'type': 'resale',
              });
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
                            (BuildContext context, StateSetter insideState) {
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
          child: Icon(
            FontAwesomeIcons.plus,
          ),
        ),
      ),
    );
  }
}
