import 'dart:convert';
import 'dart:io';

import 'package:camera_application/model/login_request.dart';
import 'package:camera_application/model/login_response.dart';
import 'package:camera_application/model/photo.dart';
import 'package:camera_application/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'application_config.dart';
import 'main.dart';

class PhotoService {
  static var dio = Dio();

  static Future<List<User>> getUsers(String url) async {
    try {
      Response response = await dio.get("https://reqres.in/api/users?page=1&per_page=11");

      Map<String, dynamic> responseBody = response.data;

      return (responseBody['data'] as List<dynamic>)
          .map((x) => User.fromJson(x))
          .toList();
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }


  static Future login(String username, String password) async {
    LoginRequest loginRequest = new LoginRequest(username, password);

    final msg = jsonEncode({"username":"${username}","password":"${password}"});

    http.Response response = await http.post(
      "${BASE_API_URL}/auth/signin",
        headers: {"Content-Type": "application/json"},
      body: msg
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      return LoginResponse.fromJson(responseBody);
    } else {
      return null; // in case no user found
    }

  }
  static Future fetchPhotos() async {

    String token = await storage.read(key: "jwt");
    String userId = await storage.read(key: "userId");

    Map<String, String> headers = {
      "Authorization": "Bearer $token"
    };

    var response = await http.get("${BASE_API_URL}/user/${userId}/images", headers: headers);

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((photo) => Photo.fromJson(photo)).toList();
    } else {
      print('Failed to load photos');
      return null;
    }
  }


  static Future uploadPhoto(File file, String filename, String type) async {

    String token = await storage.read(key: "jwt");
    String userId = await storage.read(key: "userId");

    ///MultiPart request
    var request = http.MultipartRequest(
      'POST', Uri.parse("${BASE_API_URL}/user/${userId}/upload"),

    );
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Content-type": "multipart/form-data"
    };
    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: filename,
      ),
    );
    request.headers.addAll(headers);
    request.fields.addAll({
      "filename": "${filename}",
      "filetype": "${type}"
    });
    var res = await request.send();
    return res.statusCode;
  }


}