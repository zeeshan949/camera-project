import 'dart:async';

import 'package:camera_application/mbtiles_image_provider.dart';
import 'package:camera_application/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'application_config.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
import 'package:flutter_mbtiles_extractor/flutter_mbtiles_extractor.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ApplicationState applicationState = null;
  bool downloading = false;
  String downloadProgress = '0';
  bool isDownloaded = false;

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
    applicationState = Provider.of<ApplicationState>(context);

    var downloadProgress =
        Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(children: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Download Progress")))
      ]),
      Row(children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(10.0),
          child: LinearPercentIndicator(
            width: 250.0,
            lineHeight: 14.0,
            percent: applicationState.downloadPercent,
            backgroundColor: Colors.grey,
            progressColor: Colors.green,
            trailing: Text("(" +
                formatBytes(applicationState.downloadedProgressFileSize, 2) +
                " / " +
                formatBytes(applicationState.totalDownloadFileSize, 2) +
                ")", style: TextStyle(fontSize: 10),),
          ),
        ))
      ])
    ]);

    var extractProgress =
    Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(children: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Extraction Progress")))
      ]),
      Row(children: [
        Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: LinearPercentIndicator(
                width: 250.0,
                lineHeight: 14.0,
                percent: double.parse(applicationState.extractPercent)/100,
                backgroundColor: Colors.grey,
                progressColor: Colors.lightGreenAccent,
                trailing: Text("(" + applicationState.extractPercent.toString() + "%)", style: TextStyle(fontSize: 10),),
              ),
            ))
      ])
    ]);

    return Scaffold(
      appBar: AppBar(
          title: Text('Application Settings'),
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
      body: Consumer<ApplicationState>(builder: (context, provider, child) {
        bool isOfflineMaps = applicationState.isMapsDownloaded;

        return Card(
            margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: IntrinsicHeight(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: Icon(Icons.map, color: isOfflineMaps ? Colors.greenAccent : Colors.redAccent,),
                        title: Text("Offline Maps"),
                        trailing: IconButton(
                            icon: Icon(isOfflineMaps
                                ? Icons.delete
                                : Icons.arrow_downward),
                            onPressed: !applicationState.isMapsDownloadInprogress ? _onDownloadButtonPressed : _onDownloadButtonPressed),
                      ),
                    )
                  ],
                ),
                applicationState.isMapsDownloadClicked
                    ? downloadProgress
                    : Row(),
                applicationState.isMapsDownloadClicked
                    ? extractProgress
                    : Row()
              ],
            )));
      }),
    );
  }

  void _onDownloadButtonPressed() async {

    if(applicationState.isMapsDownloaded){
      await deleteOfflineMaps();
      applicationState.isMapsDownloaded = false;
    }else{
      applicationState.extractPercent = "0";
      applicationState.downloadPercent = 0;
      applicationState.totalDownloadFileSize = 0;
      applicationState.downloadedProgressFileSize = 0;
      applicationState.isMapsDownloadClicked = true;
      applicationState.isMapsDownloadInprogress = true;
      await downloadFile(MAPS_TILES_URL, "maps.mbtiles");
      await _extractMBTilesFile();
      applicationState.isMapsDownloadInprogress = false;
      applicationState.isMapsDownloadClicked = false;
      applicationState.isMapsDownloaded = true;
    }
  }

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  Future<void> deleteOfflineMaps()async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String pathToFile = appDirectory.path + '/maps';
    final dir = Directory(pathToFile);
    if(dir.existsSync()){
      dir.deleteSync(recursive: true);
    }else{
      print("Directory does not exist");
    }

    print("Removed extracted files");
  }

  Future<void> downloadFile(uri, fileName) async {
    applicationState.isMapsDownloadInprogress = true;

    String savePath = await getFilePath(fileName);
    Dio dio = Dio();

    await dio.download(
      uri,
      savePath,
      onReceiveProgress: (rcv, total) {
        applicationState.downloadPercent = ((rcv / total));
        applicationState.downloadedProgressFileSize = rcv;
        applicationState.totalDownloadFileSize = total;

        if (downloadProgress == '100') {
          applicationState.isMapsDownloaded = true;
        } else if (double.parse(downloadProgress) < 100) {}
      },
      deleteOnError: true,
    ).then((_) async{
        if (downloadProgress == '100') {
          applicationState.isMapsDownloadInprogress = false;
          applicationState.isMapsDownloaded = true;
        }

    });
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';
    Directory dir = await getApplicationDocumentsDirectory();
    path = '${dir.path}/$uniqueFileName';
    return path;
  }

  Future<void> _extractMBTilesFile() async {
    try {

      Directory appDirectory = await getApplicationDocumentsDirectory();
      String pathToFile = appDirectory.path + '/maps.mbtiles';


      ExtractResult extractResult = await MBTilesExtractor.extractMBTilesFile(
        //Path of the selected file.
        pathToFile,
        //Path of the extraction folder.
        desiredPath: appDirectory.path,
        //Vital in android.
        requestPermissions: true,
        //Deletes the *.mbtiles file after the extraction is completed.
        removeAfterExtract: true,
        //Stops is one tile could not be extracted.
        stopOnError: true,
        //Returns the list of tiles once the extraction is completed.
        returnReference: true,
        //If true the reference of tiles is returned but the extraction is not performed.
        onlyReference: false,
        //The schema of the mbtiles file.
        schema: Schema.XYZ,
        //Progress update callback
        onProgress: (total, progress) {
          var percent = progress / total;

          if (percent == 1.0) {
            applicationState.isMapsExtractInprogress = false;
            applicationState.extractPercent = "100";
          } else {
            applicationState.isMapsExtractInprogress = true;
            applicationState.extractPercent = '${(percent * 100).toStringAsFixed(2)}';
          }
        },
      );
    } catch (ex, st) {
      print(ex);
      print(st);
    }
    applicationState.isMapsExtractInprogress = false;
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
