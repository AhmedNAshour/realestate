import 'package:flutter/material.dart';
import 'package:realestate/components/modalBottomSheetTabSelector.dart';
import 'package:realestate/components/modalBottomSheetheader.dart';
import 'package:realestate/screens/shared/login.dart';
import 'package:realestate/screens/shared/signup.dart';

class LoginSignupModalBottomSheet extends StatefulWidget {
  const LoginSignupModalBottomSheet({
    Key key,
    @required this.modalBottomSheetState,
  }) : super(key: key);

  // final int selectedTab;
  // final Function changeSelectedTab;
  final StateSetter modalBottomSheetState;

  @override
  _LoginSignupModalBottomSheetState createState() =>
      _LoginSignupModalBottomSheetState();
}

class _LoginSignupModalBottomSheetState
    extends State<LoginSignupModalBottomSheet> {
  int selectedTab = 0;
  changeSelectedTab(int newSelection) {
    selectedTab = newSelection;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ModalBottomSheetHeader(
          title: 'Login/Signup',
          sizedBoxWidth: 0.22,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
          ),
          child: Row(
            children: [
              ModalBottomSheetTabSelector(
                tabIndex: 0,
                selectedTab: selectedTab,
                changeSelectedTab: changeSelectedTab,
                state: widget.modalBottomSheetState,
                tabName: 'Login',
              ),
              SizedBox(
                width: size.width * 0.02,
              ),
              ModalBottomSheetTabSelector(
                tabIndex: 1,
                selectedTab: selectedTab,
                changeSelectedTab: changeSelectedTab,
                state: widget.modalBottomSheetState,
                tabName: 'Signup',
              ),
            ],
          ),
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Expanded(
          child: Container(
            child: selectedTab == 0 ? Login() : Signup(),
          ),
        ),
      ],
    );
  }
}
