import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';

part 'local_storage_util.g.dart';

// References: https://www.filledstacks.com/snippet/shared-preferences-service-in-flutter-for-code-maintainability/

String OBJECT_EXPIRED = '-1';

@JsonSerializable()
class ExpiryObject {
  dynamic content;
  DateTime expireAt;

  ExpiryObject({this.content, this.expireAt});

  factory ExpiryObject.fromJson(Map<String, dynamic> json) => _$ExpiryObjectFromJson(json);
  Map<String, dynamic> toJson() => _$ExpiryObjectToJson(this);

}

class LocalStorageUtil {
  static LocalStorageUtil _instance;
  static SharedPreferences _preferences;

  static Future<LocalStorageUtil> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageUtil();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  // updated _saveToDisk function that handles all types
  void saveToDisk({String key, dynamic value, int expiryInSecond=-1}){
    if(expiryInSecond!=-1){
        DateTime expireAt= DateTime.now().add(Duration(seconds: expiryInSecond));
        ExpiryObject expiryObject = ExpiryObject(content: value, expireAt: expireAt);
        value = expiryObject.toJson();
    }

    if(value is String) {
      _preferences.setString(key, value);
    }
    if(value is bool) {
      _preferences.setBool(key, value);
    }
    if(value is int) {
      _preferences.setInt(key, value);
    }
    if(value is double) {
      _preferences.setDouble(key, value);
    }

    if(value is List<dynamic>) {
      List<dynamic> v = value;
      _preferences.setStringList(key, v.map((e) => json.encode(e)).toList());
    }


    if (value is Map<String, dynamic>){
      value = json.encode(value);
      _preferences.setString(key, value);
    }

  }

  dynamic _getExpiryObject(String key, var value){
    try{
      ExpiryObject object =  ExpiryObject.fromJson(value);
      if(object.expireAt.isBefore(DateTime.now())){
        _preferences.remove(key);
        return OBJECT_EXPIRED;
      }
      else{
        return object.content;
      }
    }
    catch(e){
        return null;
    }
  }

  @visibleForTesting
  dynamic get(String key) {
    return _preferences.get(key);
  }

  dynamic getFromDisk(String key) {
    var value = get(key);
    if(value is List){
      print(value);
      return (value as List).map((e) => json.decode(e)).toList();
    }
    try {
      value = json.decode(value);
    }
    catch(e){
      print(e);
      return value;
    }
    dynamic expiryResponse = _getExpiryObject(key, value);
    if (expiryResponse==OBJECT_EXPIRED) return null;
    if(expiryResponse==null) return value;
    return expiryResponse;
  }

}