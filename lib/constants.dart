import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xFF27153E);

const kHeaderTextStyle =
    TextStyle(fontSize: 50.0, color: Colors.white, fontWeight: FontWeight.bold);

const kSubHeaderTextStyle =
    TextStyle(fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.bold);

const kSubHeader2TextStyle =
    TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold);

const kInputDecoration = InputDecoration(
  errorStyle: TextStyle(color: Color(0xFFF9287B), fontSize: 15),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF7E1CEA), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(18.0)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF7E1CEA), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(18.0)),
  ),
  hintText: 'Enter a Value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
);
