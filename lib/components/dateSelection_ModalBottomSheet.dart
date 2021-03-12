import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:realestate/components/forms/rounded_button..dart';
import 'package:realestate/components/forms/text_field_container.dart';
import 'package:realestate/components/modalBottomSheetheader.dart';
import 'package:realestate/constants.dart';
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
  }) : super(key: key);

  final String dateSearch;
  final TextEditingController dateTextController;
  final Function changeDateSearch;
  final Property property;
  final UserData user;

  @override
  _DateSelectionFormState createState() => _DateSelectionFormState();
}

class _DateSelectionFormState extends State<DateSelectionForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            ModalBottomSheetHeader(
              title: 'Select Date',
              sizedBoxWidth: 0.22,
            ),
            TextFieldContainer(
              child: TextFormField(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  ).then((value) => setState(() {
                        if (value == null) {
                          widget.changeDateSearch('');
                          widget.dateTextController.text = '';
                          // showCancel =
                          //     false;
                        } else {
                          widget.changeDateSearch(
                              DateFormat('yyyy-MM-dd').format(value));
                          widget.dateTextController.text =
                              DateFormat('yyyy-MM-dd').format(value);
                        }
                      }));
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
                    icon: Icon(FontAwesomeIcons.calendar)),
                onChanged: (val) {
                  widget.changeDateSearch(val);
                },
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
                      property: widget.property,
                      date: widget.dateSearch,
                      user: widget.user,
                    );
                    Navigator.pop(context);
                  },
                )..show();
              },
            ),
          ],
        ),
      ),
    );
  }
}
