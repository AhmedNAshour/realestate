import 'package:flutter/material.dart';
import 'package:realestate/components/forms/text_field_container.dart';
import 'package:realestate/constants.dart';

class RoundedInputField extends StatelessWidget {
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.validator,
    this.obsecureText,
    this.labelText,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final FormFieldValidator validator;
  final bool obsecureText;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: obsecureText,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
          labelStyle: TextStyle(
            color: kPrimaryLightTextColor,
          ),
          icon: Icon(
            icon,
            color: kPrimaryLightTextColor,
          ),
          hintText: hintText,
          focusColor: kPrimaryColor,
        ),
      ),
    );
  }
}
