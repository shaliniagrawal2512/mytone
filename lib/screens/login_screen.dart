import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mytone/components/sign_up_page.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/components/raised_buttons.dart';
import 'package:mytone/screens/Forget_Password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BottomNavigation.dart';
import 'package:mytone/Services/authentication.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool obscure = true;
bool showSpinner = false;
final _formKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    void getLogIn() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          showSpinner = true;
        });
        _formKey.currentState!.save();
        String result = await Authenticate()
            .signInWithEmail(emailController.text, passwordController.text);
        if (result == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', emailController.text);
          emailController.text = '';
          passwordController.text = '';
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BottomNavigation()));
          setState(() {
            showSpinner = false;
          });
        } else {
          setState(() {
            showSpinner = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result), duration: Duration(seconds: 7)));
        }
      }
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Log in',
                  style: kHeaderTextStyle,
                ),
                SizedBox(height: 20.0),
                TextFormField(
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
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please Enter Password';
                      return null;
                    },
                    controller: passwordController,
                    obscureText: obscure,
                    decoration: kInputDecoration.copyWith(
                        hintText: 'Enter Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscure ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                        ))),
                SizedBox(
                  width: 30,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ForgotPassword.id);
                      },
                      style: TextButton.styleFrom(
                        alignment: Alignment.topRight,
                        fixedSize: Size.fromWidth(20),
                        //tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text('Forget Password',
                          style: TextStyle(color: Color(0xFF7E1CEA)))),
                ),
                RaisedGradientButton(
                    color: [
                      Color(0xFFF9287B),
                      Color(0xFF7E1CEA),
                    ],
                    label: 'Log in',
                    icon: Icons.login_rounded,
                    onPressed: getLogIn),
                SignUpPage()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
