import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:realestate/components/lists_cards/compoundsList.dart';
import 'package:realestate/constants.dart';
import 'package:realestate/models/compound.dart';
import 'package:realestate/models/user.dart';
import 'package:realestate/screens/admin/selectLocation_governate.dart';
import 'package:realestate/services/database.dart';

class CompoundsSearch extends StatefulWidget {
  static const id = 'CompoundsSearch';
  @override
  _CompoundsSearchState createState() => _CompoundsSearchState();
}

class _CompoundsSearchState extends State<CompoundsSearch> {
  String governateFilter = '';
  String districtFilter = '';
  String areaFilter = '';
  Map navigationData = {};
  bool firstTime = true;

  changeGovernateFilter(newGovernateFilter) {
    setState(() {
      governateFilter = newGovernateFilter;
    });
  }

  changeDistrictFilter(newDistrictFilter) {
    setState(() {
      districtFilter = districtFilter;
    });
  }

  changeAreaFilter(newAreaFilter) {
    setState(() {
      areaFilter = areaFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    navigationData = ModalRoute.of(context).settings.arguments;
    if (firstTime) districtFilter = navigationData['district'];
    firstTime = false;
    List filters = [
      governateFilter,
      districtFilter,
      areaFilter,
    ];

    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return MultiProvider(
      providers: [
        StreamProvider<List<Compound>>.value(
          value: DatabaseService().getCompoundsBySearch(
            limited: false,
            governate: governateFilter,
            district: districtFilter,
            area: areaFilter,
            status: 'active',
          ),
        ),
        StreamProvider<UserData>.value(
            value:
                user != null ? DatabaseService(uid: user.uid).userData : null)
      ],
      child: Scaffold(
        // backgroundColor: Color(0xFFF0F0F0),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Header
              Row(
                children: [
                  BackButton(
                    color: kSecondaryColor,
                  ),
                  Text(
                    'Compounds',
                    style: TextStyle(
                      color: kPrimaryTextColor,
                      fontSize: size.height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              //Filtering
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
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
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.02,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: size.width * 0.02,
                                              right: size.width * 0.02,
                                              bottom: size.height * 0.01),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: size.height * 0.001,
                                                color: kPrimaryLightColor,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Filter',
                                                style: TextStyle(
                                                    fontSize: size.width * 0.05,
                                                    color: kPrimaryTextColor),
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.28),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  color: kPrimaryTextColor,
                                                  size: size.width * 0.085,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              },
                            ),
                          );
                        },
                        isScrollControlled: true,
                      );
                    },
                    child: Container(
                      height: height * 0.05,
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            FontAwesomeIcons.filter,
                            color: kPrimaryLightColor,
                            size: height * 0.025,
                          ),
                          Text(
                            'Filter',
                            style: TextStyle(
                              color: kPrimaryLightColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Expanded(
                    child: Container(
                      height: height * 0.05,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filters.length,
                        itemBuilder: (context, index) {
                          return filters[index] != null && filters[index] != ''
                              ? Container(
                                  margin: EdgeInsets.only(right: width * 0.02),
                                  padding: EdgeInsets.all(width * 0.02),
                                  height: height * 0.05,
                                  decoration: BoxDecoration(
                                    color: kPrimaryLightColor,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: kPrimaryTextColor,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        filters[index].toString(),
                                        style: TextStyle(
                                          color: kPrimaryTextColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (index == 0) {
                                              governateFilter = '';
                                              districtFilter = '';
                                            } else if (index == 1) {
                                              districtFilter = '';
                                              areaFilter = '';
                                            } else if (index == 2) {
                                              areaFilter = '';
                                            }
                                          });
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.minusCircle,
                                          color: kSecondaryColor,
                                          size: width * 0.05,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: CompoundsList('', Axis.vertical),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: StreamBuilder<UserData>(
            stream:
                user != null ? DatabaseService(uid: user.uid).userData : null,
            builder: (context, snapshot) {
              UserData userData = snapshot.data;
              if (snapshot.hasData) {
                return userData.role == 'admin'
                    ? FloatingActionButton(
                        backgroundColor: kSecondaryColor,
                        onPressed: () {
                          Navigator.pushNamed(context, SelectGovernate.id,
                              arguments: {
                                'type': 'compound',
                              });
                        },
                        child: Icon(
                          FontAwesomeIcons.plus,
                        ),
                      )
                    : Container();
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
