import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytone/constants.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mytone/components/raised_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytone/screens/BottomNavigation.dart';

enum PhoneNumScreen { SHOW_MOBILE_ENTER_WIDGET, SHOW_OTP_FORM_WIDGET }

class PhoneScreen extends StatefulWidget {
  static const String id = 'phone_screen';

  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
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
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BottomNavigation();
        }));
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some Error Occurred. Try Again Later')));
    }
  }

  Widget showMobilePhoneWidget(context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get Started..',
              style: kHeaderTextStyle,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: usernameController,
              decoration: kInputDecoration.copyWith(
                hintText: 'Enter User Name',
                prefixIcon: Icon(Icons.account_circle, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(8),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              child: IntlPhoneField(
                controller: phoneController,
                showDropdownIcon: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Enter phone number',
                  border: InputBorder.none,
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {},
              ),
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
                await _auth.verifyPhoneNumber(
                    phoneNumber: "+91${phoneController.text}",
                    verificationCompleted: (phoneAuthCredential) async {},
                    verificationFailed: (verificationFailed) {
                      print(verificationFailed);
                    },
                    codeSent: (verificationID, resendingToken) async {
                      setState(() {
                        currentState = PhoneNumScreen.SHOW_OTP_FORM_WIDGET;
                        this.verificationID = verificationID;
                      });
                    },
                    codeAutoRetrievalTimeout: (verificationID) async {});
              },
            ),
          ]),
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
              style: TextStyle(color: Colors.white),
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: kInputDecoration.copyWith(
                  prefixIcon: Icon(
                    Icons.refresh,
                    color: Colors.grey,
                  ),
                  hintText: "Enter Your OTP",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
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
      body: currentState == PhoneNumScreen.SHOW_MOBILE_ENTER_WIDGET
          ? showMobilePhoneWidget(context)
          : showOtpFormWidget(context),
    );
  }
}
