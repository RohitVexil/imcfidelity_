import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imcfidelity/Utils/ComFun.dart';
import 'package:imcfidelity/Utils/Constaints.dart';
import 'package:imcfidelity/Utils/Urls.dart';
import 'package:imcfidelity/home_page.dart';

class AddBeneficiary extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<AddBeneficiary> {


  TextEditingController nameC ;
  TextEditingController mobNoC ;
  TextEditingController accNoC ;
  TextEditingController ifscC ;

  String dropdownValue = 'Account Type';
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState()
  {
    nameC = new TextEditingController();
    mobNoC = new TextEditingController();
    accNoC = new TextEditingController();
    ifscC = new TextEditingController();

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


    final header = FlatButton(
      child: Text(
        'ADD BENEFICIARY',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {},
    );


    final dropDown = Container(
      width: MediaQuery.of(context).size.width
      ,height:50,
      alignment: Alignment(0.0, 0.0),
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: dropdownValue,
        onChanged: (String newValue) {

          setState(() {
            dropdownValue = newValue;
            print("dropdownValue"+newValue);
          });
        },

        items: <String>['Account Type', 'Savings', 'Current']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        })
            .toList(),
      ),
    );



    final name = TextField(
      controller: nameC,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Beneficiary Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final mobNo = TextField(
      controller: mobNoC,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Mobile Number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final accNo = TextField(
      controller: accNoC,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Account Number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

  final ifsc = TextField(
      controller: ifscC,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'IFSC Code',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final addAcc = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {

          if(nameC.text.length==0)
          {
              ComFun.showSnackBar(_scaffoldkey, 'Enter Beneficiary Name');
          }

          else if(mobNoC.text.length==0)
          {
            ComFun.showSnackBar(_scaffoldkey, 'Enter Mobile Number');
          }

          else if(accNoC.text.length==0)
          {
            ComFun.showSnackBar(_scaffoldkey, 'Enter Account Number');
          }

          else if(nameC.text.length==0)
          {
            ComFun.showSnackBar(_scaffoldkey, 'Enter IFSC Code');
          }

          else {
            getBeneficiaryRegistration();
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Add Account', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: ComFun.appBar("Add Beneficiary"),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 10.0),
            header,
            SizedBox(height: 10.0),
            dropDown,
            SizedBox(height: 10.0),
            name,
            SizedBox(height: 10.0),
            mobNo,
            SizedBox(height: 10.0),
            accNo,
            SizedBox(height: 10.0),
            ifsc,
            SizedBox(height: 10.0),
            addAcc
          ],
        ),
      ),
    );
  }

  String  jsonData()
  {
    var values = {
      'BenifMobileNo':mobNoC.text.toString(),
      'BenificiaryAccountNo': accNoC.text.toString(),
      'BenificiaryIFSCCode': ifscC.text.toString(),
      'BenificiaryName': nameC.text.toString(),
      'BenificiaryType': "Savings",
      'SenderMemberId': "M0010040",
      'MobileNo':'9677077777',
    };
    return json.encode(values).toString();
  }

  Future getBeneficiaryRegistration() async{
    final response = await http.post(Urls.BenificiaryRegistration,
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

}
