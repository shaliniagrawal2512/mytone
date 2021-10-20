import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytone/constants.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mytone/components/raised_buttons.dart';
import 'package:mytone/components/textfield.dart';

class PhoneScreen extends StatefulWidget {
  static const String id = 'phone_screen';

  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
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
              TextInputField(
                label: 'User Name',
                obscure: false,
                prefixIcon: Icons.account_circle,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(18))),
                  child: IntlPhoneField(
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
              ),
              SizedBox(height: 20.0),
              RaisedGradientButton(color: [
                Color(0xFFF9287B),
                Color(0xFF7E1CEA),
              ], label: 'Next', icon: Icons.navigate_next, onPressed: () {}),
            ]),
      ),
    );
  }
}
