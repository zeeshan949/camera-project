import 'dart:io';

import 'package:camera_application/home.dart';
import 'package:camera_application/model/login_response.dart';
import 'package:camera_application/photo_service.dart';
import 'package:camera_application/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => new _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _username = "";
  String _password = "";
  ApplicationState applicationState = null;

  @override
  Widget build(BuildContext context) {
    applicationState = Provider.of<ApplicationState>(context);
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[
            TextFormField(
                onSaved: (String val) => setState(() => _username = val),
                initialValue: "",
                validator: (value) {
                  if (value.isEmpty) {
                    return "Username is required";
                  }

                  if (value.length < 2) {
                    return "Username should contain more than 3 characters";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'Username',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)))),
            SizedBox(height: 30.0),
            TextFormField(
                onSaved: (String val) => setState(() => _password = val),
                initialValue: "",
                validator: (value) {
                  if (value.isEmpty) {
                    return "Password is required";
                  }

                  if (value.length < 2) {
                    return "Password should contain more than 3 characters";
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Password',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)))),
            SizedBox(height: 45.0),
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Color(0xff01A0C7),
              child: MaterialButton(
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    _formKey.currentState.save(); // Save value in form mapped fields
                    LoginResponse loginResponse = await PhotoService.login(_username, _password);
                    if (loginResponse != null) {
                      applicationState.isLoggedIn = true;
                      storage.write(key: "jwt", value: loginResponse.accessToken);
                      storage.write(key: "userId", value: loginResponse.id.toString());

                      bool isOfflineMap = await isOfflineMapExist();
                      applicationState.isMapsDownloaded = isOfflineMap;


                      Navigator.pushNamed(context, '/home');
                      _formKey.currentState.reset();
                    } else {
                      Fluttertoast.showToast(
                          msg: "No account was found matching that username and password.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }else{
                    Fluttertoast.showToast(
                        msg: "Please enter the values",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }


                },
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                child: Text("Login",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ));
  }

  Future<bool> isOfflineMapExist() async{
    String path = '';

    Directory dir = await getApplicationDocumentsDirectory();

    // Store Base Path for future use
    applicationState.applicationDirectoryPath = dir.path;
    path = '${dir.path}/maps';
    return await Directory(path).exists();
  }
}
