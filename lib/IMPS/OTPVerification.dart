import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imcfidelity/Utils/ComFun.dart';
import 'package:imcfidelity/Utils/Constaints.dart';
import 'package:imcfidelity/Utils/Urls.dart';
import 'package:imcfidelity/home_page.dart';

class OTPVerification extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<OTPVerification> {


  TextEditingController otp ;
  TextEditingController pwdCon ;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState()
  {
    otp = new TextEditingController();
    pwdCon = new TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      key: _scaffoldkey,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 68.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final otpTf = TextField(
      controller: otp,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Enter OTP',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );


    final resendOtptf = Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {

              reSendOTP();

          },
          padding: EdgeInsets.all(12),
          color: Colors.lightBlueAccent,
          child: Text('Resend OTP', style: TextStyle(color: Colors.white)),)
    );

    final verifyOTP = Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if(otp.text.length==0)
          {
            ComFun.showSnackBar(_scaffoldkey,'Enter OTP first');
          }
          else {
            verOtp();
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Verify', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: ComFun.appBar("Verify OTP"),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            otpTf,
            SizedBox(height: 8.0),
            verifyOTP,
            SizedBox(height: 24.0),
            resendOtptf
          ],
        ),
      ),
    );
  }

  String  jsonData()
  {
    var values = {
      'Memberid':'M0010040',
      'OTP': otp.text.toString().trim()
    };

    print("json/bob"+json.encode(values));
    return json.encode(values).toString();
  }

  String  jsonDataForResendOtp()
  {
    var values = {
      'MemberId':'M0010040',
      'MobileNo':'9511185853',
    };
    return json.encode(values).toString();
  }

  Future verOtp() async{
    final response = await http.post(Urls.VerifyOTP,
        headers: {
          HttpHeaders.contentTypeHeader: Constaints.contypeJson
        },
        body: jsonData()
    );
    print("resBob"+response.body.toString());
    //print("resBob1"+jsonDecode(""));

    Map<String, dynamic> map = jsonDecode(response.body.toString()); // import 'dart:convert';

    if(map['Status']) {
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

  Future reSendOTP() async{
    final response = await http.post(Urls.ReSendOTP,
        headers: {
          HttpHeaders.contentTypeHeader: Constaints.contypeJson
        },
        body:jsonDataForResendOtp(),

    );
    print("resBob"+response.body.toString());
    //print("resBob1"+jsonDecode(""));

    Map<String, dynamic> map = jsonDecode(response.body.toString()); // import 'dart:convert';

    if(map['Status']) {
      ComFun.showSnackBar(_scaffoldkey,map['Message']);
//      Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => HomePage()),
//      );
    }
    else {
      ComFun.showSnackBar(_scaffoldkey,map['Message']);
    }
  }

}