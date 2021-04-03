import 'dart:async';

import 'package:camera_application/gallary.dart';
import 'package:camera_application/offline_map.dart';
import 'package:camera_application/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'application_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:io';
import 'main.dart';
import 'package:connectivity/connectivity.dart';
import 'generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';


class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  bool isMapLoaded = false;
  StreamSubscription subscription = null;
  ApplicationState applicationState = null;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        applicationState.isInternetAvailable = true;
      } else {
        applicationState.isInternetAvailable = false;
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  Card makeDashboardItem(String title, Icon icon) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
          child: new InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(child: icon),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    applicationState = Provider.of<ApplicationState>(context);
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
            appBar: AppBar(
                title: Text(LocaleKeys.home_page.tr()),
                elevation: 24.0,
                automaticallyImplyLeading: false,
                centerTitle: true,
                actions: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.logout),
                    onPressed: () {
                      _showDialog(context);
                    },
                  ),
                ]),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(3.0),
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/maps');
                    },
                    child: makeDashboardItem(
                        LocaleKeys.home_map.tr(), Icon(Icons.map, size: 40.0, color: Colors.red)),
                    behavior: HitTestBehavior.opaque,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/gallery');
                    },
                    child: makeDashboardItem(
                        LocaleKeys.home_gallery.tr(),
                        Icon(Icons.photo_library,
                            size: 40.0, color: Colors.blue)),
                    behavior: HitTestBehavior.opaque,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/users');
                    },
                    child: makeDashboardItem(
                        LocaleKeys.home_user_list.tr(),
                        Icon(Icons.supervised_user_circle,
                            size: 40.0, color: Colors.green)),
                    behavior: HitTestBehavior.opaque,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    child: makeDashboardItem(
                        LocaleKeys.home_settings.tr(),
                        Icon(Icons.settings,
                            size: 40.0, color: Colors.deepPurple)),
                    behavior: HitTestBehavior.opaque,
                  )
                ],
              ),
            )));
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Log out"),
          content: new Text("Are you sure you want to logout?"),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("Yes"),
              onPressed: () {
                logOut();
                Navigator.pushNamedAndRemoveUntil(context, '/login', ModalRoute.withName('/login'));
              },
            ),
            new ElevatedButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future logOut() async {
    await storage.deleteAll();
  }
}
