
import 'package:flutter/material.dart';
import 'package:imcfidelity/login_page.dart';

void main() {
  runApp(MaterialApp(home:MyApp(),debugShowCheckedModeBanner: false
  ));

//  final filename = 'file.txt';
//  new File(filename).writeAsString('some content')
//      .then((File file) {
//    // Do something with the file.
//  });
//
//  new File('file.txt').readAsString().then((String contents) {
//    print("txtFile"+contents);
//  });
}

class MyApp extends StatefulWidget {

  _myApp1 createState() => _myApp1();
}

class _myApp1 extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircleAvatar(
          radius: 72.0,
          backgroundImage: AssetImage('assets/logo.png'),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(
      Duration(seconds: 3),
          () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      },
    );
  }
}


