import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/text/gradient_text.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mytone/Services/authentication.dart';
import 'package:mytone/components/raised_buttons.dart';
import 'package:mytone/components/sign_up_page.dart';
import '../constants.dart';

final _formKey = GlobalKey<FormState>();
TextEditingController emailController = TextEditingController();
bool showSpinner = false;

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);
  static const String id = 'Forget_Password';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        showSpinner = true;
      });
      String result = await Authenticate().forgetPassword(emailController.text);
      setState(() {
        showSpinner = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result,
          ),
        ),
      );
      emailController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Reset Password',
                style: kHeaderTextStyle,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: GradientText(
                      'Reset Link will be sent to your email id !!',
                      style: TextStyle(fontSize: 18.0),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFF9287B),
                          Color(0xFF7E1CEA),
                        ],
                      ))),
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    } else if (!value.contains('@')) {
                      return 'Please Enter a Valid Email Address';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: kInputDecoration.copyWith(
                      hintText: 'Enter Email Address',
                      prefixIcon: Icon(
                        Icons.email,
                      )),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 10),
              RaisedGradientButton(
                label: 'Send Email',
                color: [
                  Color(0xFFF9287B),
                  Color(0xFF7E1CEA),
                ],
                onPressed: () {
                  resetPassword();
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Color(0xFF7E1CEA)),
                ),
              ),
              SignUpPage(),
            ],
          ),
        ),
      ),
    );
  }
}
