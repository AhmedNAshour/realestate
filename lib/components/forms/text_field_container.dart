import 'package:flutter/material.dart';
import 'package:realestate/constants.dart';

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: kPrimaryColor,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: child,
    );
  }
}
