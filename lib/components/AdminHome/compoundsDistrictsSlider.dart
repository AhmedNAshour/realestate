import 'package:flutter/material.dart';
import 'package:realestate/constants.dart';
import 'package:realestate/screens/shared/compounds_search.dart';

class CompoundsDistrictsSlider extends StatelessWidget {
  CompoundsDistrictsSlider({
    Key key,
  }) : super(key: key);

  final List<String> districts = [
    'New Cairo',
    'Heliopolis',
    'Madinty',
    'El 3alamen',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.12,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: districts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, CompoundsSearch.id, arguments: {
                'district': districts[index],
              });
            },
            child: Container(
              width: size.width * 0.3,
              margin: EdgeInsets.symmetric(
                vertical: size.height * 0.02,
                horizontal: size.width * 0.01,
              ),
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.02,
                horizontal: size.width * 0.02,
              ),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  districts[index],
                  style: TextStyle(
                    color: kPrimaryLightColor,
                    // fontSize:
                    //     size.width * 0.04,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
