import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class ApplicationState with ChangeNotifier {

  bool _isLoggedIn = false;
  bool _isInternetAvailable = true;
  bool _isMapsDownloaded = false;
  bool _isMapsDownloadClicked = false;
  bool _isMapsDownloadInprogress = false;
  double _downloadPercent = 0.0;
  String _extractPercent = "0";
  bool _isMapsExtractInprogress = false;
  int _totalDownloadFileSize = 0;
  int _downloadedProgressFileSize = 0;
  String _applicationDirectoryPath = "";
  List<Marker> _marketList = [];

  set marketList(List<Marker> val){
    _marketList = val;
    notifyListeners();
  }

  get marketList{
    return _marketList;
  }

  set isMapsDownloadInprogress(bool val){
    _isMapsDownloadInprogress = val;
    notifyListeners();
  }

  get isMapsDownloadInprogress{
    return _isMapsDownloadInprogress;
  }

  set isMapsExtractInprogress(bool val){
    _isMapsExtractInprogress = val;
    notifyListeners();
  }

  get isMapsExtractInprogress{
    return _isMapsExtractInprogress;
  }


  set downloadedProgressFileSize(int val){
    _downloadedProgressFileSize = val;
    notifyListeners();
  }

  get downloadedProgressFileSize{
    return _downloadedProgressFileSize;
  }

  set totalDownloadFileSize(int val){
    _totalDownloadFileSize = val;
    notifyListeners();
  }

  get totalDownloadFileSize{
    return _totalDownloadFileSize;
  }
  set extractPercent(String val){
    _extractPercent = val;
    notifyListeners();
  }

  get extractPercent{
    return _extractPercent;
  }

  set downloadPercent(double val){
    _downloadPercent = val;
    notifyListeners();
  }

  get downloadPercent{
    return _downloadPercent;
  }

  set isMapsDownloadClicked(bool val){
    _isMapsDownloadClicked = val;
    notifyListeners();
  }

  get isMapsDownloadClicked{
    return _isMapsDownloadClicked;
  }

  set applicationDirectoryPath(String val){
    _applicationDirectoryPath = val;
    notifyListeners();
  }

  get applicationDirectoryPath{
    return _applicationDirectoryPath;
  }

  set isLoggedIn(bool val){
    _isLoggedIn = val;
    notifyListeners();
  }

  get isLoggedIn{
    return _isLoggedIn;
  }

  get isMapsDownloaded{
    return _isMapsDownloaded;
  }

  set isInternetAvailable(bool value){
    _isInternetAvailable = value;
    notifyListeners();
  }

  set isMapsDownloaded(bool value){
    _isMapsDownloaded = value;
    notifyListeners();
  }

  get isInternetAvailable{
    return _isInternetAvailable;
  }

}