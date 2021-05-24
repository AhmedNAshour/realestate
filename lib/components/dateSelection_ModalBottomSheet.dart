import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:realestate/components/forms/rounded_button..dart';
import 'package:realestate/components/forms/text_field_container.dart';
import 'package:realestate/components/modalBottomSheetheader.dart';
import 'package:realestate/constants.dart';
import 'package:realestate/models/compound.dart';
import 'package:realestate/models/property.dart';
import 'package:realestate/models/user.dart';
import 'package:realestate/services/database.dart';

class DateSelectionForm extends StatefulWidget {
  const DateSelectionForm({
    Key key,
    @required this.dateSearch,
    @required this.dateTextController,
    this.changeDateSearch,
    this.property,
    this.user,
    this.type,
    this.compound,
  }) : super(key: key);

  final String dateSearch;
  final TextEditingController dateTextController;
  final Function changeDateSearch;
  final Property property;
  final UserData user;
  final String type;
  final Compound compound;

  @override
  _DateSelectionFormState createState() => _DateSelectionFormState();
}

class _DateSelectionFormState extends State<DateSelectionForm> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return SingleChildScrollView(
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModalBottomSheetHeader(
              title: 'Select Date',
              sizedBoxWidth: 0.22,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: TextFieldContainer(
                child: TextFormField(
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(2030),
                      onChanged: (date) {},
                      onConfirm: (date) {
                        if (date == null) {
                          widget.changeDateSearch('');
                          widget.dateTextController.text = '';
                          // showCancel =
                          //     false;
                        } else {
                          widget.changeDateSearch(
                              '${DateFormat("MMM").format(date)} ${DateFormat("d").format(date)} - ${DateFormat("jm").format(date)}');
                          widget.dateTextController.text =
                              '${DateFormat("MMM").format(date)} ${DateFormat("d").format(date)} - ${DateFormat("jm").format(date)}';
                        }
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.en,
                    );
                  },
                  keyboardType: null,
                  controller: widget.dateTextController,
                  // initialValue: widget.dateSearch,
                  decoration: InputDecoration(
                    focusColor: kPrimaryColor,
                    labelStyle: TextStyle(
                      color: kPrimaryColor,
                    ),
                    labelText: 'Select Date',
                    icon: Icon(FontAwesomeIcons.calendar),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    widget.changeDateSearch(val);
                  },
                ),
              ),
            ),
            RoundedButton(
              text: 'Book Appointment',
              press: () async {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Book Appointment',
                  desc: 'Are your sure you want to book an appointment ?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () async {
                    await DatabaseService().updateRequestData(
                      compound: widget.compound,
                      property: widget.property,
                      date: widget.dateSearch,
                      user: widget.user,
                    );
                    Navigator.pop(context);
                  },
                )..show();
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
