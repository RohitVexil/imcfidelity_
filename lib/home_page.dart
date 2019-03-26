import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:imcfidelity/AddMobileNo.dart';
import 'package:imcfidelity/IMPS/ImpsBeneficiaryList.dart';
import 'package:imcfidelity/IMPS/OTPVerification.dart';
import 'package:imcfidelity/Utils/ComFun.dart';
import 'package:imcfidelity/Utils/Constaints.dart';
import 'package:imcfidelity/Utils/SPClass.dart';
import 'package:imcfidelity/Utils/Urls.dart';
import 'package:imcfidelity/login_page.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shared preferences demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Shared preferences demo'),
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static String tag = 'home-page';

  TextEditingController logoutTc,mobNOTc ;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  String dropdownValue = '--Select Mobile No.--';


  @override
  Widget build(BuildContext context) {

    logoutTc = new TextEditingController();
    mobNOTc = new TextEditingController();

    final alucard = ComFun.logo(_scaffoldkey);

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Welcome IMC Fidelity',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'IMC Fidelity Member App',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );


    final mobNODropDown  = new GestureDetector(

      onTap:()
      {

        hitAPImemberMobileList();
      },

    child : Container(
      width: MediaQuery.of(context).size.width
        ,height:50,
      alignment: Alignment(0.0, 0.0),
      color: Colors.white,

      child: Container(
        alignment: Alignment(0.0, 0.0),
        color: Colors.white,

        child: TextField(controller:mobNOTc,
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: 'Select Mobile No.'),enabled: false),
      ),

    ),
    );


    final IMPS  = new GestureDetector(
      onTap: ()
      {
        hitAPImemberDashBoard();
      },

      child: Container(
        padding:EdgeInsets.fromLTRB(0.0,2.0,0.0,0.0),
        width: MediaQuery.of(context).size.width,
        child: Container(

          alignment: Alignment(0.0, 0.0),
          color: Colors.white,
          constraints: BoxConstraints(
              maxHeight: 100.0,
              maxWidth: 100.0,
              minWidth: 50.0,
              minHeight: 50.0
          ),
          child: Text("IMPS"),
        ),
      ),
    ) ;

    final addMob  = new GestureDetector(

      onTap: ()
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddMobileNo()),
        );
      },

      child: Container(
        padding:EdgeInsets.fromLTRB(0.0,2.0,0.0,0.0),
        width: MediaQuery.of(context).size.width,
        child: Container(
          alignment: Alignment(0.0, 0.0),
          color: Colors.white,
          constraints: BoxConstraints(
              maxHeight: 100.0,
              maxWidth: 100.0,
              minWidth: 50.0,
              minHeight: 50.0
          ),
          child: Text("Add Mobile Number"),
        ),
      ),
    ) ;


    final logout  =  new GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
       child: new Container(
         padding:EdgeInsets.fromLTRB(0.0,2.0,0.0,0.0),
         width: MediaQuery.of(context).size.width,
        child: Container(
          alignment: Alignment(0.0, 0.0),
          color: Colors.white,
          constraints: BoxConstraints(
              maxHeight: 100.0,
              maxWidth: 100.0,
              minWidth: 50.0,
              minHeight: 50.0
          ),
          child: Text("Logout"),
        ),
      ),

    ) ;

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: Column(

        children: <Widget>[alucard, welcome, lorem, mobNODropDown, IMPS, addMob, logout],

      ),
    );

    return Scaffold(
      appBar: ComFun.appBar("Dashboard"),
      body: body,
    );
  }

  String  jsonData()
  {
    var values = {
      'MemberId':SPClass.memberID,
       //'MobileNo': "9511185853"
      'MobileNo': mobNOTc.text

    };

    print("json/bob"+json.encode(values)); // {"a":1,"b":2,"c":3}
    return json.encode(values).toString();
  }

  
  Future hitAPImemberDashBoard() async{
    final response = await http.post(Urls.memberDashBoard,
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

       String agent_id  =  map['MemberDashBoard']['agent_id'];

       if(agent_id.length==0)
       {
         execute_IMPSSenderRegistration();
       }
       else
         {
           execute_BeneficiaryDetails();
         }
    }
    else {
      ComFun.showSnackBar(_scaffoldkey,map['Message']);
    }
  }

  String  jsonDataMemberMobileList()
  {
    var values = {
      'MemberId':SPClass.memberID
    };
    print("json/bob"+json.encode(values));
    return json.encode(values).toString();
  }

  Future  hitAPImemberMobileList() async{
    final response = await http.post(Urls.memberMobileList,
        headers: {
          HttpHeaders.contentTypeHeader: Constaints.contypeJson
        },
        body: jsonDataMemberMobileList()
    );
    print("resBob"+response.body.toString());
    MemMobListres = jsonDecode(response.body.toString()); // import 'dart:convert';

    if(MemMobListres['Status']) {

      _settingModalBottomSheet(context);

    }
    else {
      ComFun.showSnackBar(_scaffoldkey,MemMobListres['Message']);
    }
  }

  Future  execute_IMPSSenderRegistration() async{
    final response = await http.post(Urls.IMPSSenderRegistration,
        headers: {
          HttpHeaders.contentTypeHeader: Constaints.contypeJson
        },
        body: jsonData()
    );
    print("resBob"+response.body.toString());
    Map<String, dynamic> res = jsonDecode(response.body.toString()); // import 'dart:convert';

    if(res['Status']) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OTPVerification()),
      );
    }
    else {
      ComFun.showSnackBar(_scaffoldkey,res['Message']);
    }
  }

 Future  execute_BeneficiaryDetails() async{
    final response = await http.post(Urls.BenificiaryDetail,
        headers: {
          HttpHeaders.contentTypeHeader: Constaints.contypeJson
        },
        body: jsonData()
    );
    print("resBob"+response.body.toString());
    Map<String, dynamic> res = jsonDecode(response.body.toString()); // import 'dart:convert';

    if(res['Status']) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImpsBeneficiaryList(res)),
      );
    }
    else {
      ComFun.showSnackBar(_scaffoldkey,res['Message']);
    }
  }

  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
           return Column(
            children: <Widget>[

                 Expanded(child:getHomePageBody(context))

            ],
          );
        }
    );
  }

  getHomePageBody(BuildContext context) {
    print("itemCount"+MemMobListres.length.toString());

    return ListView.builder( shrinkWrap: true,
      itemCount: MemMobListres['MemberMobileList'].length,
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
                MemMobListres['MemberMobileList'][index]['MobileNo'],
                style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              onTap: () {

                  mobNOTc.text = MemMobListres['MemberMobileList'][index]['MobileNo'];
                  print("sdssdf"+mobNOTc.text.toString());

              },
            )
          ],
        ));
  }

  Map<String, dynamic> MemMobListres;

}
