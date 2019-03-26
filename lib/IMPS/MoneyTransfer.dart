import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imcfidelity/Utils/ComFun.dart';
import 'package:imcfidelity/Utils/Constaints.dart';
import 'package:imcfidelity/Utils/Urls.dart';

class MoneyTransfer extends StatefulWidget {

  Map<String, dynamic> map;
  int index  = 0;

  MoneyTransfer(Map<String, dynamic> map,int index) {
    this.map = map;
    this.index = index;
  }

  @override
  _LoginPageState createState() => new _LoginPageState(map,index);
}

class _LoginPageState extends State<MoneyTransfer> {
  Map<String, dynamic> map;
  int index  = 0;

  _LoginPageState(Map<String, dynamic> map,  int index) {
    this.map = map;
    this.index  = index;

  }

  TextEditingController userIDCon;
  TextEditingController moneyEtC;

  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    userIDCon = new TextEditingController();
    moneyEtC = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final logo  = ComFun.logo(_scaffoldkey);

    final transferMoney = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => AddBeneficiary()),
//            );
            executeIMPSFundTransfer();
          },
          padding: EdgeInsets.all(12),
          color: Colors.lightBlueAccent,
          child: Text('Transfer Money',
              style: TextStyle(color: Colors.white)),
        ));

    final moneyEt = TextField(
      controller: moneyEtC,
      autofocus: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(

        hintText: 'Enter Amount',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),

      ),
    );

    return Scaffold(
      appBar: ComFun.appBar("IMPS Money Transfer"),
      backgroundColor: Colors.white,
      body: Container(
        padding:  EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          SizedBox(height: 48.0),
          logo,
          Container(child: _getItemUI(context)),SizedBox(height: 10.0),
          moneyEt,SizedBox(height: 10.0),transferMoney
        ],
      ),),
    );

//        body: new Container(
//
//            child: getHomePageBody(context)));
  }

  String jsonData() {
    var values = {'AccountNumber': map['Data'][index]['AccountNumber'],
      'AccountType': "Savings",
    'AgentMemberId': "M0010040",
    'BeneficiaryName': map['Data'][index]['BeneficiaryName'],
    'Beneficiarymobile': map['Data'][index]['BeneficiaryMobileNo'],
    'IFSC': map['Data'][index]['IFSC'],
    'TransactionType': "IMPS",
    'TransferAmount': moneyEtC.text,
    'MobileNo': "9677077777"};

    print("json/bob" + json.encode(values));
    return json.encode(values).toString();
  }

  Future executeIMPSFundTransfer() async {
    final response = await http.post(Urls.IMPSFundTransferNew,
        headers: {HttpHeaders.contentTypeHeader: Constaints.contypeJson},
        body: jsonData());
    print("resBob" + response.body.toString());
    //print("resBob1"+jsonDecode(""));

    Map<String, dynamic> map = jsonDecode(response.body.toString()); // import 'dart:convert';

    if (map['Status']) {
      ComFun.showSnackBar(
          _scaffoldkey, map['AddMemberMobileNo']['TransMessage']);
//      Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => HomePage()),
//      );
    } else {
      ComFun.showSnackBar(_scaffoldkey, map['Message']);
    }
  }


  Widget _getItemUI(BuildContext context) {
    return new Card(
        child: new Column(
          children: <Widget>[
            new ListTile(
              title: new Text(
                map['Data'][index]['BeneficiaryName'],
                style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(map['Data'][index]['AccountNumber'],
                        style: new TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.normal)),

                    new Text(map['Data'][index]['AccountType'],
                        style: new TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.normal)),

                    new Text(map['Data'][index]['BeneficiaryMobileNo'],
                        style: new TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.normal)),

                    new Text(map['Data'][index]['BeneficiaryCode'],
                        style: new TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.normal)),

                    new Text(map['Data'][index]['IFSC'],
                        style: new TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.normal)),
                  ]),

              onTap: () {

              },
            )
          ],
        ));
  }
}
