import 'dart:async';
import 'dart:io';

import 'package:camera_application/photo_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_view/gallery_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import 'application_config.dart';
import 'main.dart';

class GallaryPage extends StatefulWidget {
  @override
  _GallaryState createState() => _GallaryState();
}

class _GallaryState extends State<GallaryPage> {
  File _image;
  final picker = ImagePicker();
  List<String> imageUrlList = List.empty(growable: true);
  Future _photoListFuture;

  Future refresh() async {
    setState(() {
      _photoListFuture = PhotoService.fetchPhotos();
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        await PhotoService.uploadPhoto(
            _image, basename(_image.path), lookupMimeType(_image.path))
            .then((value) => {

            })
          .onError((error, stackTrace) => {});

        Fluttertoast.showToast(
            msg: "Photo Uploaded successfully.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print('No image selected.');
      }

      refresh();
  }

  @override
  void initState() {
    super.initState();
    _photoListFuture = PhotoService.fetchPhotos();
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




  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
          appBar: AppBar(
              title: Text('Your Uploaded Images'),
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
          body: Center(
            child: FutureBuilder(
              future: _photoListFuture,
              builder: (context, snapshot) {
                imageUrlList.clear();
                if (snapshot.hasData) {
                  for (var value in snapshot.data) {
                    imageUrlList.add("${BASE_API_URL}/image/" + value.imageUrl);
                  }
                }
                return GalleryView(imageUrlList: imageUrlList);
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: getImage,
            tooltip: 'Capture Photo',
            child: Icon(Icons.add_a_photo),
          ),
        ));
  }
}
