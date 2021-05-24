import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:realestate/components/forms/rounded_button..dart';
import '../../constants.dart';

class Added extends StatelessWidget {
  Added(this.type);
  final String type;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: kPrimaryLightColor,
          child: Center(
            child: Column(
              children: [
                Lottie.asset('assets/animations/added.json'),
                Text(
                  '$type Added',
                  style: TextStyle(
                    fontSize: size.width * 0.1,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                RoundedButton(
                    text: 'Home',
                    press: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
