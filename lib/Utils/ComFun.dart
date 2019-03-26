import 'package:flutter/material.dart';

class ComFun{

  static void showSnackBar(GlobalKey<ScaffoldState> _scaffoldkey,String msg) {
    Scaffold.of(_scaffoldkey.currentContext).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  static AppBar appBar(String msg) {
    var appBar  =  new  AppBar(
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text(msg),
      centerTitle: true
    );

    return appBar;
  }

  static Hero logo(GlobalKey<ScaffoldState> _scaffoldkey) {
    final logo = Hero(
      tag: 'hero',
      key: _scaffoldkey,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 68.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    return logo;
  }

}