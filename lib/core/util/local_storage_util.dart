import 'package:shared_preferences/shared_preferences.dart';


// References: https://www.filledstacks.com/snippet/shared-preferences-service-in-flutter-for-code-maintainability/

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
  void saveToDisk<T>(String key, T content){
    print(content.runtimeType);
    if(content is String) {
      _preferences.setString(key, content);
    }
    if(content is bool) {
      _preferences.setBool(key, content);
    }
    if(content is int) {
      _preferences.setInt(key, content);
    }
    if(content is double) {
      _preferences.setDouble(key, content);
    }
    if(content is List<String>) {
      _preferences.setStringList(key, content);
    }

  }

  dynamic getFromDisk(String key) {
    var value  = _preferences.get(key);
    return value;
  }

}