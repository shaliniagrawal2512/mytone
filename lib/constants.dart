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
// filled: true,
// fillColor: Colors.red,
// focusColor: Colors.blue,
  prefixIcon: IconTheme(
    data: IconThemeData(color: Colors.grey),
    child: Icon(Icons.add),
  ),
  hintText: 'Enter a Value',
  hintStyle: TextStyle(),
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
