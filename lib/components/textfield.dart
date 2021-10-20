import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String label;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function? onPressed;
  final bool obscure;
  final TextInputType? keyboardType;
  TextInputField(
      {required this.label,
      this.prefixIcon,
      this.suffixIcon,
      this.onPressed,
      required this.obscure,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: InputDecoration(
          // filled: true,
          // fillColor: Colors.red,
          // focusColor: Colors.blue,
          prefixIcon: IconTheme(
            data: IconThemeData(color: Colors.grey),
            child: Icon(prefixIcon),
          ),
          suffixIcon: IconTheme(
            data: IconThemeData(color: Colors.white),
            child: IconButton(
              disabledColor: Colors.grey,
              icon: Icon(suffixIcon),
              onPressed: onPressed as void Function()?,
            ),
          ),
          hintText: label,
          hintStyle: TextStyle(),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
          ),
        ),
      ),
    );
  }
}
