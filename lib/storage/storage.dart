import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hquality/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';



class StorageService {
  final ValueNotifier<dynamic> _storageNotifier = ValueNotifier<dynamic>({});

  StorageService(){
    _initStorageNotifier();
  }

  void _updateNotifier() async {
    var state = {
      "current_language": await get("current_language"),
      "user_session": await get("user_session"),
    };
    _storageNotifier.value = state;
  }

  Future<void> _initStorageNotifier() async {
    _updateNotifier();
  }

  dynamic get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String objString = prefs.getString(key) ?? "";
    if(objString.isEmpty){
      if(key == "current_language"){
        return defaultLanguage;
      }
      return null;
    }
    return jsonDecode(objString);
  }
  void remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    _updateNotifier();
  }

  void set(String key, dynamic obj) async {
    final prefs = await SharedPreferences.getInstance();
    String objString = "";
    if(obj != null){
      objString = jsonEncode(obj);
    }
    await prefs.setString(key, objString);
    _updateNotifier();
  }
  
  ValueNotifier<dynamic> get storageNotifier => _storageNotifier;
  
}
