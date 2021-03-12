import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryLightColor,
      child: Center(
        child: Lottie.asset('assets/house-loading-icon.json'),
      ),
    );
  }
}
