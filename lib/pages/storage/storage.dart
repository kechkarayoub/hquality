import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hquality/utils/utils.dart';


class StorageService {
  final ValueNotifier<dynamic> _storageNotifier = ValueNotifier<dynamic>({});

  StorageService(){
    _initStorageNotifier();
  }



  void _updateNotifier() async {
    var state = {
      "current_language": await get("current_language"),
      "user_session": await get("user_session"),
      "random": Random().nextInt(10000),
    };
    _storageNotifier.value = state;
  }

  Future<void> _initStorageNotifier() async {
    var val = _storageNotifier.value;
  print('.... before1: $val');
    _updateNotifier();
     val = _storageNotifier.value;
  print('.... after1: $val');
  }

  Future<dynamic> get(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     String objString = prefs.getString(key) ?? "";
//     if(objString.isEmpty){
//       if(key == "current_language"){
//         return defaultLanguage;
//       }
//       return null;
//     }
//     return jsonDecode(objString);
  }
  Future<void> remove(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(key);
//     var val = _storageNotifier.value;
//   print('.... before2: $val');
//     _updateNotifier();
//      val = _storageNotifier.value;
//   print('.... after2: $val');
  }

  Future<void> set(String key, dynamic obj) async {
//     final prefs = await SharedPreferences.getInstance();
//     String objString = "";
//     if(obj != null){
//       objString = jsonEncode(obj);
//     }
//     await prefs.setString(key, objString);
//     var val = _storageNotifier.value;
//   print('.... objString: $objString');
//   print('.... before3: $val');
//     _updateNotifier();
//      val = _storageNotifier.value;
//   print('.... after3: $val');
  }
  
  ValueNotifier<dynamic> get storageNotifier => _storageNotifier;
  
}
