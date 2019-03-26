import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imcfidelity/IMPS/AddBeneficiary.dart';
import 'package:imcfidelity/IMPS/MoneyTransfer.dart';
import 'package:imcfidelity/Utils/ComFun.dart';
import 'package:imcfidelity/Utils/Constaints.dart';
import 'package:imcfidelity/Utils/SPClass.dart';
import 'package:imcfidelity/Utils/Urls.dart';

class ImpsBeneficiaryList extends StatefulWidget {
  static String tag = 'login-page';
  Map<String, dynamic> map;

  ImpsBeneficiaryList(Map<String, dynamic> map) {
    this.map = map;

    print("mapBOb1" + this.map.toString());
  }

  @override
  _LoginPageState createState() => new _LoginPageState(map);
}

class _LoginPageState extends State<ImpsBeneficiaryList> {
  Map<String, dynamic> map;

  _LoginPageState(Map<String, dynamic> map) {
    this.map = map;

    print("mapBOb2" + this.map.toString());
  }

  TextEditingController userIDCon;

  TextEditingController pwdCon;

  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    userIDCon = new TextEditingController();
    pwdCon = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final logo  = ComFun.logo(_scaffoldkey);

    final aDDNEWBENEFICIARY = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBeneficiary()),
            );
          },
          padding: EdgeInsets.all(12),
          color: Colors.lightBlueAccent,
          child: Text('ADD NEW BENEFICIARY',
              style: TextStyle(color: Colors.white)),
        ));

    return Scaffold(
      appBar: ComFun.appBar("IMPS Money Transfer"),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: 24.0),
          logo,
          aDDNEWBENEFICIARY,
          Expanded(child: getHomePageBody(context))
        ],
      ),
    );

//        body: new Container(
//
//            child: getHomePageBody(context)));
  }

  String jsonData() {
    var values = {'MemberId': SPClass.memberID, 'MobileNo': "7339191737"};

    print("json/bob" + json.encode(values));
    return json.encode(values).toString();
  }

  Future createPost() async {
    final response = await http.post(Urls.addMemberMobileNo,
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

  getHomePageBody(BuildContext context) {
    return ListView.builder(
      itemCount: map['Data'].length,
      itemBuilder: _getItemUI,
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _getItemUI(BuildContext context, int index) {
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
                new Text(map['Data'][index]['IFSC'],
                    style: new TextStyle(
                        fontSize: 11.0, fontWeight: FontWeight.normal)),
              ]),

          onTap: () {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MoneyTransfer(map,index)),
            );
          },
        )
      ],
    ));
  }
}
