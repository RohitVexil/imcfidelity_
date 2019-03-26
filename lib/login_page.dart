import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imcfidelity/Utils/ComFun.dart';
import 'package:imcfidelity/Utils/Constaints.dart';
import 'package:imcfidelity/Utils/SPClass.dart';
import 'package:imcfidelity/Utils/Urls.dart';
import 'package:imcfidelity/home_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  TextEditingController userIDCon ;
  TextEditingController pwdCon ;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState()
  {
    userIDCon = new TextEditingController();
    pwdCon = new TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final logo = ComFun.logo(_scaffoldkey);

    final email = TextField(
      controller: userIDCon,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'MemberID',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextField(
      controller: pwdCon,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if(userIDCon.text.length==0 && pwdCon.text.length==0)
          {
            ComFun.showSnackBar(_scaffoldkey,'Invalid login credentials');
          }
          else {
            createPost();
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      appBar: ComFun.appBar("Login"),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }


  String  jsonData()
  {
//    var values = {
//      'MemberId':'M0010040',
//      'Password': "Ajay@1996"
//    };

      var values = {
      'MemberId':userIDCon.text.toString(),
      'Password':pwdCon.text.toString()
    };

    print("json/bob"+json.encode(values));
    return json.encode(values).toString();
  }

  Future createPost() async{
    final response = await http.post(Urls.memberLogin,
        headers: {
          HttpHeaders.contentTypeHeader: Constaints.contypeJson
        },
        body: jsonData()
    );
    print("resBob"+response.body.toString());
    //print("resBob1"+jsonDecode(""));

    Map<String, dynamic> map = jsonDecode(response.body.toString()); // import 'dart:convert';

    if(map['Status']) {
      SPClass.memberID = userIDCon.text.toString();
      ComFun.showSnackBar(_scaffoldkey,map['Message']);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    else {
      ComFun.showSnackBar(_scaffoldkey,map['Message']);
    }
  }

}
