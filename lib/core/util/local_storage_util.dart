import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';

part 'local_storage_util.g.dart';

// References: https://www.filledstacks.com/snippet/shared-preferences-service-in-flutter-for-code-maintainability/

const String OBJECT_EXPIRED = '-1';

@JsonSerializable()
class ExpiryObject {
  ExpiryObject({this.content, this.expireAt});
  factory ExpiryObject.fromJson(Map<String, dynamic> json) => _$ExpiryObjectFromJson(json);
  Map<String, dynamic> toJson() => _$ExpiryObjectToJson(this);

  dynamic content;
  DateTime expireAt;

}

class LocalStorageUtil {
  static LocalStorageUtil _instance;
  static SharedPreferences _preferences;

  static Future<LocalStorageUtil> getInstance() async {
    _instance ??= LocalStorageUtil();
    _preferences ??= await SharedPreferences.getInstance();
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
      final List<dynamic> v = value;
      _preferences.setStringList(key, v.map((dynamic e) => json.encode(e)).toList());
    }


    if (value is Map<String, dynamic>){
      _preferences.setString(key, json.encode(value));
    }

  }

  dynamic _getExpiryObject(String key, dynamic value){
    try{
      final ExpiryObject object =  ExpiryObject.fromJson(value as Map<String, dynamic>);
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
    dynamic value = get(key);
    if(value is List<String>){
      return value.map<dynamic>((String e) => json.decode(e)).toList();
    }
    try {
      value = json.decode(value as String);
    }
    catch(e){
      return value;
    }
    final dynamic expiryResponse = _getExpiryObject(key, value);
    if (expiryResponse==OBJECT_EXPIRED)
     return null;
    if(expiryResponse==null)
     return value;
    return expiryResponse;
  }

}