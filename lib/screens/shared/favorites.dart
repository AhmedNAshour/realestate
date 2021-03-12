import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realestate/components/lists_cards/propertiesList.dart';
import 'package:realestate/components/lists_cards/propertiesList_admin.dart';
import 'package:realestate/constants.dart';
import 'package:realestate/models/property.dart';
import 'package:realestate/models/user.dart';
import 'package:realestate/services/database.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    MyUser user = Provider.of<MyUser>(context);
    UserData userData = Provider.of<UserData>(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Favorites',
                  style: TextStyle(
                    color: kPrimaryTextColor,
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: Container(
                  child: MultiProvider(
                    providers: [
                      StreamProvider<List<Property>>.value(
                        value: DatabaseService()
                            .getPropertiesBySearch(limited: false),
                      ),
                    ],
                    child: userData != null
                        ? userData.role == 'admin'
                            ? PropertiesListAdmin.getLikes(
                                '', Axis.vertical, userData.likes)
                            : PropertiesList.searchByFavorites(
                                '', Axis.vertical, userData.likes)
                        : PropertiesList('', Axis.vertical),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
