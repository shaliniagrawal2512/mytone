import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mytone/Services/authentication.dart';
import 'package:mytone/components/raised_buttons.dart';

import '../constants.dart';

bool showSpinner = false;

class ChangePassword extends StatefulWidget {
  static const String id = 'changePassword';
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var _newPasswordController = TextEditingController();
  var _repeatPasswordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/mytone.png'),
                    colorFilter: ColorFilter.mode(
                        kBackgroundColor, BlendMode.difference),
                    alignment: Alignment.topCenter)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration:
                      kInputDecoration.copyWith(hintText: 'Enter new Password'),
                  controller: _newPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Password';
                    } else if (value.length < 6) {
                      return 'Password is too weak';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                    decoration: kInputDecoration.copyWith(
                        hintText: 'Enter confirm Password'),
                    obscureText: true,
                    controller: _repeatPasswordController,
                    validator: (value) {
                      return _newPasswordController.text == value
                          ? null
                          : "Please validate your entered password";
                    }),
                SizedBox(height: 10),
                RaisedGradientButton(
                    color: [
                      Color(0xFFF9287B),
                      Color(0xFF7E1CEA),
                    ],
                    label: 'Save Password',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        Authenticate()
                            .updateUserPassword(_newPasswordController.text);
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("your password is updated"),
                            duration: Duration(seconds: 7)));
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
