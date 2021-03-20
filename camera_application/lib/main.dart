
import 'dart:io';

import 'package:camera_application/connection_status.dart';
import 'package:camera_application/home.dart';
import 'package:camera_application/login_form.dart';
import 'package:camera_application/maps_page.dart';
import 'package:camera_application/model/login_response.dart';
import 'package:camera_application/offline_map.dart';
import 'package:camera_application/photo_service.dart';
import 'package:camera_application/settings_page.dart';
import 'package:camera_application/state/application_state.dart';
import 'package:camera_application/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'gallary.dart';

final storage = FlutterSecureStorage();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ApplicationState>(create:(final BuildContext context) {
          return ApplicationState();
        })
      ],
      child: MaterialApp(
        title: 'login Screen',
        routes: {
          '/login': (context) => MainPage(),
          '/home': (context) => HomePage(),
          '/settings': (context) => SettingsPage(),
          '/gallery': (context) => GallaryPage(),
          '/maps': (context) => MapsPage(),
          '/users': (context) => UsersPage()

        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainPage(title: 'Flutter Login'),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;
  ApplicationState applicationState = null;

  @override
  Widget build(BuildContext context) {
    applicationState = Provider.of<ApplicationState>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ LoginForm()
              ],
            ),
          ),
        ),
      ),
    );

  }

}
