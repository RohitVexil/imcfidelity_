import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imcfidelity/Utils/ComFun.dart';
import 'package:imcfidelity/Utils/Constaints.dart';
import 'package:imcfidelity/Utils/SPClass.dart';
import 'package:imcfidelity/Utils/Urls.dart';

class AddMobileNo extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<AddMobileNo> {


  TextEditingController userIDCon ;
  TextEditingController mobNoTC ;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState()
  {
    mobNoTC = new TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final logo = ComFun.logo(_scaffoldkey);

    final mobNo = TextField(
      maxLength: 10,
      controller: mobNoTC,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter Mobile Number',
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
          if(mobNoTC.text.length==0)
          {
            ComFun.showSnackBar(_scaffoldkey,'Mobile No. is Required!');
          }
          else {
            createPost();
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Add Mobile Number', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: ComFun.appBar("Add Mobile Numer"),

      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 8.0),
            mobNo,
            loginButton,
          ],
        ),
      ),
    );
  }

//  Future<List<User>> fetchUsersFromGitHub() async {
//    final response = await http.post(Urls.memberLogin);
//    print(response.body);
//    List responseJson = json.decode(response.body.toString());
//    List<User> userList = createUserList(responseJson);
//    print("BOB1"+userList.toString());
//    return userList;
//  }
//
//  List<User> createUserList(List data){
//    List<User> list = new List();
//    for (int i = 0; i < data.length; i++) {
//      String title = data[i]["login"];
//      int id = data[i]["id"];
//      User movie = new User(name: title,id: id);
//      list.add(movie);
//      print("BOB2"+list.toString());
//
//    }
//    return list;
//  }

  String  jsonData()
  {
//    var values = {
//      'MemberId': userIDCon.text,
//      'Password': pwdCon.text
//    };

    var values = {
      'MemberId':SPClass.memberID,
      'MobileNo': mobNoTC.text.toString().trim()
    };

    print("json/bob"+json.encode(values));
    return json.encode(values).toString();
  }

  Future createPost() async{
    final response = await http.post(Urls.addMemberMobileNo,
        headers: {
          HttpHeaders.contentTypeHeader: Constaints.contypeJson
        },
        body: jsonData()
    );
    print("resBob"+response.body.toString());
    //print("resBob1"+jsonDecode(""));

    Map<String, dynamic> map = jsonDecode(response.body.toString()); // import 'dart:convert';

    if(map['Status']) {
      ComFun.showSnackBar(_scaffoldkey,map['AddMemberMobileNo']['TransMessage']);
//      Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => HomePage()),
//      );
    }
    else {
      ComFun.showSnackBar(_scaffoldkey,map['Message']);
    }
  }

  // new
  Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

}
