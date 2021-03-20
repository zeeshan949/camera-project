import 'dart:async';

import 'package:camera_application/mbtiles_image_provider.dart';
import 'package:camera_application/model/user.dart';
import 'package:camera_application/photo_service.dart';
import 'package:camera_application/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class UsersPage extends StatefulWidget {
  @override
  _USersPageState createState() => _USersPageState();
}

class _USersPageState extends State<UsersPage> {

  ApplicationState _applicationState = null;
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    _applicationState = Provider.of<ApplicationState>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Users List'),
          elevation: 24.0,
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.logout),
              onPressed: () {
                _showDialog(context);
              },
            ),
          ]),
      body: Consumer<ApplicationState>(
          builder: (context, provider, child) {
            return FutureBuilder<List<User>>(
              future: PhotoService.getUsers(''),
              builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('Please wait its loading...'));
                } else {
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int position) {
                          var name = snapshot.data[position].firstName + " " + snapshot.data[position].lastName;
                          var avatarUrl = snapshot.data[position].avatar;
                          var email = snapshot.data[position].email;
                          return Card(margin: EdgeInsets.fromLTRB(8, 6, 8, 6),
                              elevation: 1.0,
                              child: ListTile(title: Text(name, style: TextStyle(fontWeight: FontWeight.bold),), trailing: Text(email),
                                  leading: Image.network(
                                avatarUrl,
                                fit: BoxFit.fill,
                              )));
                        });
                }
              },
            );
          }
      ),
    );
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
