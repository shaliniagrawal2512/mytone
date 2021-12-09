import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mytone/constants.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mytone/components/raised_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytone/screens/BottomNavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mytone/Services/authentication.dart';

TextEditingController phoneController = TextEditingController();
TextEditingController otpController = TextEditingController();
TextEditingController usernameController = TextEditingController();
bool showSpinner = false;
String countryCode = '+91';
final _formKey = GlobalKey<FormState>();
enum PhoneNumScreen { SHOW_MOBILE_ENTER_WIDGET, SHOW_OTP_FORM_WIDGET }

class PhoneScreen extends StatefulWidget {
  static const String id = 'phone_screen';

  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  PhoneNumScreen currentState = PhoneNumScreen.SHOW_MOBILE_ENTER_WIDGET;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationID = "";

  void signOutME() async {
    await _auth.signOut();
  }

  void signInWithPhoneAuthCred(AuthCredential phoneAuthCredential) async {
    try {
      final authCred = await _auth.signInWithCredential(phoneAuthCredential);

      if (authCred.user != null) {
        Authenticate().postDetailsToFirestore(usernameController.text);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('phoneNumber', phoneController.text);
        phoneController.text = '';
        otpController.text = '';
        usernameController.text = '';
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => BottomNavigation()));
        setState(() {
          showSpinner = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        showSpinner = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some Error Occurred. Try Again Later')));
    }
  }

  Widget showMobilePhoneWidget(context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Get Started..',
                style: kHeaderTextStyle,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: usernameController,
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
              SizedBox(height: 20),
              IntlPhoneField(
                controller: phoneController,
                showDropdownIcon: false,
                initialCountryCode: 'IN',
                onCountryChanged: (value) {
                  countryCode = value.countryCode.toString();
                },
                decoration:
                    kInputDecoration.copyWith(hintText: "Enter a Phone Number"),
              ),
              SizedBox(height: 20.0),
              RaisedGradientButton(
                  color: [
                    Color(0xFFF9287B),
                    Color(0xFF7E1CEA),
                  ],
                  label: 'Generate OTP',
                  icon: Icons.navigate_next,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        showSpinner = true;
                      });
                      await _auth.verifyPhoneNumber(
                          phoneNumber: "$countryCode${phoneController.text}",
                          verificationCompleted: (phoneAuthCredential) async {},
                          verificationFailed: (verificationFailed) {
                            print(verificationFailed);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Some Error Occurred. Try Again Later'),
                              duration: Duration(seconds: 7),
                            ));
                          },
                          codeSent: (verificationID, resendingToken) async {
                            setState(() {
                              currentState =
                                  PhoneNumScreen.SHOW_OTP_FORM_WIDGET;
                              this.verificationID = verificationID;
                            });
                          },
                          codeAutoRetrievalTimeout: (verificationID) async {});
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  }),
            ]),
      ),
    );
  }

  Widget showOtpFormWidget(context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            image: DecorationImage(
          alignment: Alignment.topCenter,
          image: AssetImage('images/mytone.png'),
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter OTP send to ${phoneController.text}",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: kInputDecoration.copyWith(
                  prefixIcon: Icon(
                    Icons.refresh,
                  ),
                  hintText: "Enter Your OTP",
                )),
            SizedBox(
              height: 10,
            ),
            RaisedGradientButton(
                icon: Icons.check_box,
                color: [
                  Color(0xFFF9287B),
                  Color(0xFF7E1CEA),
                ],
                label: 'Verify',
                onPressed: () {
                  setState(() {
                    showSpinner = true;
                  });
                  AuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                          verificationId: verificationID,
                          smsCode: otpController.text);
                  signInWithPhoneAuthCred(phoneAuthCredential);
                })
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: currentState == PhoneNumScreen.SHOW_MOBILE_ENTER_WIDGET
            ? showMobilePhoneWidget(context)
            : showOtpFormWidget(context),
      ),
    );
  }
}
