import 'package:flutter/material.dart';
import 'package:mytone/Services/authentication.dart';
import 'package:mytone/components/raised_buttons.dart';
import 'package:mytone/screens/BottomNavigation.dart';
import 'package:mytone/screens/login_screen.dart';
import 'package:mytone/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController nameController = TextEditingController();
bool obscure = true;
bool showSpinner = false;
final _formKey = GlobalKey<FormState>();

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    void getRegister() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          showSpinner = true;
        });
        _formKey.currentState!.save();
        String result = await Authenticate()
            .signUpWithEmail(emailController.text, passwordController.text);
        if (result == 'success') {
          Authenticate().postDetailsToFirestore(nameController.text);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', emailController.text);
          emailController.text = '';
          passwordController.text = '';
          nameController.text = '';
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
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign up',
                  style: kHeaderTextStyle,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username can\'t be null';
                    } else if (value.length <= 3) {
                      return 'Please Enter more than 3 characters';
                    }
                    return null;
                  },
                  decoration: kInputDecoration.copyWith(
                      hintText: 'Enter User Name',
                      prefixIcon: Icon(
                        Icons.account_circle,
                      )),
                ),
                SizedBox(height: 10.0),
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
                SizedBox(height: 10.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Password';
                    } else if (value.length < 6) {
                      return 'Password is too weak';
                    }
                    return null;
                  },
                  controller: passwordController,
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
                      )),
                  obscureText: obscure,
                ),
                //PasswordFormField(),
                SizedBox(height: 20.0),
                RaisedGradientButton(
                  color: [
                    Color(0xFFF9287B),
                    Color(0xFF7E1CEA),
                  ],
                  label: 'Create Account',
                  icon: Icons.app_registration,
                  onPressed: getRegister,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: Text(
                          'Log in',
                          style: TextStyle(color: Color(0xFF7E1CEA)),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
