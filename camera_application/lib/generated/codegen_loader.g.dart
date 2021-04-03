// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ar = {
  "home": {
    "page": "الصفحة الرئيسية",
    "map": "خريطة",
    "gallery": "صالة عرض",
    "user_list": "قائمة المستخدمين",
    "settings": "إعدادات"
  }
};
static const Map<String,dynamic> en = {
  "home": {
    "page": "Home Page",
    "map": "Map",
    "gallery": "Gallery",
    "user_list": "Users List",
    "settings": "Settings"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": ar, "en": en};
}
