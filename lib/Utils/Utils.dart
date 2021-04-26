import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils{



  static push(BuildContext context,Widget nextRoute){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextRoute),
    );
  }
  static pushReplacement(BuildContext context,Widget nextRoute){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextRoute),
    );
  }
}