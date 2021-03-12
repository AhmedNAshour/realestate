import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:realestate/screens/admin/dataHandling_screen.dart';
import 'package:realestate/screens/shared/favorites.dart';
import 'package:realestate/screens/shared/home.dart';
import 'package:realestate/screens/admin/admin_requests_screen.dart';
import 'package:realestate/constants.dart';
import 'package:realestate/screens/shared/myProfile.dart';

class AdminNavigation extends StatefulWidget {
  @override
  _AdminNavigationState createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  int _currentIndex = 0;
  List<Widget> screens = [
    Home(),
    Favorites(),
    DataHandling(),
    AdminRequests(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFF0F0F0),
      body: screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: kPrimaryLightColor,
        backgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 200),
        height: 60,
        index: 0,
        items: [
          FaIcon(
            FontAwesomeIcons.home,
            size: 30,
            color: kPrimaryColor,
          ),
          FaIcon(
            FontAwesomeIcons.heart,
            size: 30,
            color: kPrimaryColor,
          ),
          FaIcon(
            FontAwesomeIcons.list,
            size: 30,
            color: kPrimaryColor,
          ),
          FaIcon(
            FontAwesomeIcons.bell,
            size: 30,
            color: kPrimaryColor,
          ),
          FaIcon(
            FontAwesomeIcons.user,
            size: 30,
            color: kPrimaryColor,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
