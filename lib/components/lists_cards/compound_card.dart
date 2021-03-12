import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:realestate/constants.dart';
import 'package:realestate/models/compound.dart';
import 'package:realestate/models/user.dart';
import 'package:realestate/screens/shared/compound_info.dart';
import 'package:realestate/services/database.dart';

class CompoundCard extends StatefulWidget {
  const CompoundCard({
    Key key,
    this.compound,
  }) : super(key: key);

  final Compound compound;
  @override
  _CompoundCardState createState() => _CompoundCardState();
}

class _CompoundCardState extends State<CompoundCard> {
  bool isLiked = false;
  UserData userData;

  Widget showDelete(double height, MyUser user) {
    if (user != null) {
      UserData userData = Provider.of<UserData>(context);
      if (userData != null) {
        if (userData.role == 'admin') {
          return ClipRRect(
            borderRadius: BorderRadius.circular(3000),
            child: GestureDetector(
              onTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Deactivate Compound',
                  desc: 'Are your sure you want to deactivate this compound ?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () async {
                    await DatabaseService().updateCompoundStatus(
                        compoundId: widget.compound.uid, status: 'inactive');
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
          );
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);

    if (user != null) {
      userData = Provider.of<UserData>(context);
    }

    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            CompoundInfo.id,
            arguments: {
              'compound': widget.compound,
              'user': userData,
            },
          );
        },
        child: Container(
          padding: EdgeInsets.all(width * 0.02),
          height: height * 0.3,
          width: width * 0.88,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            image: DecorationImage(
              image: widget.compound.images.isNotEmpty
                  ? NetworkImage(
                      widget.compound.images[0],
                    )
                  : AssetImage('assets/images/propertyPlaceholder.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: width * 0.04,
                top: height * 0.015,
                child: showDelete(height, user),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(width * 0.03),
                  // height: height * 0.1,
                  width: width * 0.84,
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.compound.name}',
                        style: TextStyle(
                          color: kPrimaryTextColor,
                          fontSize: height * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
