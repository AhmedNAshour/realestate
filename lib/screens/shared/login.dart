import 'package:flutter/material.dart';
import 'package:realestate/components/forms/rounded_button..dart';
import 'package:realestate/components/forms/rounded_input_field.dart';
import 'package:realestate/screens/shared/loading.dart';
import 'package:realestate/services/auth.dart';
import 'package:realestate/constants.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  // final FirebaseMessaging messaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    // configureCallbacks();
    Size size = MediaQuery.of(context).size;

    return loading
        ? Loading()
        : Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    RoundedInputField(
                      labelText: 'Email Address',
                      icon: Icons.email,
                      obsecureText: false,
                      hintText: 'Email',
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    ),
                    RoundedInputField(
                      labelText: 'Password',
                      obsecureText: true,
                      icon: Icons.lock,
                      hintText: 'Password',
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                      validator: (val) => val.length < 6
                          ? ' Enter a password 6+ chars long '
                          : null,
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () async {
                            // await _auth.signOut();
                            // Navigator.pushNamed(
                            //     context, ResetPassword.id);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    RoundedButton(
                      text: 'SIGN IN',
                      press: () async {
                        if (_formKey.currentState.validate()) {
                          print(email + ' ' + password);
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'could not sign in';
                              loading = false;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  // void configureCallbacks() {
  //   messaging.configure(
  //     onMessage: (message) async {
  //       print('onMessage: $message');
  //     },
  //   );
  // }
}
