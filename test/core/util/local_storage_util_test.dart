import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_viewer/core/util/local_storage_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';

part 'local_storage_util_test.g.dart';

@JsonSerializable()
class TestModel extends Equatable {
  String path;
  String type;
  String sha;

  TestModel({this.path, this.type, this.sha});

  @override
  List<Object> get props => [path, type, sha];

  factory TestModel.fromJson(Map<String, dynamic> json) => _$TestModelFromJson(json);
  Map<String, dynamic> toJson() => _$TestModelToJson(this);

  bool get isLeafNode => type=='blob';
}


void main(){

  final Map<String, dynamic> initialValue = <String, dynamic>{};
  const String key = '1';
  group('without expiry time', () {
    
    SharedPreferences.setMockInitialValues(initialValue);
    test('Testing of getter and setter with String', () async {
      final  LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const String value = 'Hi';
      localStorageUtil.saveToDisk(key: key, value: value);
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of getter and setter with bool', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const bool value = true;
      localStorageUtil.saveToDisk(key: key, value: value);
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of getter and setter with int', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const int value = 1;
      localStorageUtil.saveToDisk(key: key, value: value);
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of getter and setter with double', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const double value = 1.0;
      localStorageUtil.saveToDisk(key: key, value: value);
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of with List<int> object', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final dynamic value = <int>[1, 2];
      localStorageUtil.saveToDisk(key: key, value: value);
      final dynamic result = localStorageUtil.getFromDisk(key);
      print(result);
      expect(result, value);
    });

    test('Testing of with List<String> object', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final dynamic value = <String>['Hi', 'Hello'];
      localStorageUtil.saveToDisk(key: key, value: value);
      final dynamic result = localStorageUtil.getFromDisk(key);
      print(result);
      expect(result, value);
    });

    test('Testing of basic getter and setter with complex object', () async {
      final TestModel githubTreeModel = TestModel(sha: key);
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      localStorageUtil.saveToDisk(key: key, value: githubTreeModel.toJson());
      final Map<String, dynamic> temp = localStorageUtil.getFromDisk(key) as Map<String, dynamic>;
      final dynamic result = TestModel.fromJson(temp);
      expect(result, githubTreeModel);
    });

    test('Testing of basic getter and setter with List<complex object>', () async {
      final TestModel githubTreeModel = TestModel(sha: key);
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      localStorageUtil.saveToDisk(key: key, value: <dynamic>[githubTreeModel.toJson()]);
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, <dynamic>[githubTreeModel.toJson()]);
    });

  });

  group('with expiry time = 10 sec and object has not expired yet', () {
    const int expiryTimeInSecond = 10;
    test('Testing of getter and setter with String', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const String value = 'Hi';
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of getter and setter with bool', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const bool value = true;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of getter and setter with int', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const int value = 1;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of getter and setter with double', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const double value = 1.0;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });


    test('Testing of with List<String> object', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final List<String> value = <String>['Hi', 'Hello'];
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of basic getter and setter with complex object', () async {
      final TestModel githubTreeModel = TestModel(sha: key);
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      localStorageUtil.saveToDisk(key: key, value: githubTreeModel.toJson(), expiryInSecond: expiryTimeInSecond);
      final Map<String, dynamic> temp = localStorageUtil.getFromDisk(key) as Map<String, dynamic>;
      final dynamic result = TestModel.fromJson(temp);
      expect(result, githubTreeModel);
    });

    test('Testing of basic getter and setter with List<complex object>', () async {
      final TestModel githubTreeModel = TestModel(sha: key);
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      localStorageUtil.saveToDisk(key: key, value: [githubTreeModel.toJson()], expiryInSecond: expiryTimeInSecond);
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, [githubTreeModel.toJson()]);
    });
  });


  group('with expiry time = 1 sec and object has been expired yet', () {
    const int expiryTimeInSecond = 1;
    test('Testing of getter and setter with String', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const String value = 'Hi';
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, null);
    });

    test('Testing of getter and setter with bool', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const bool value = true;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, null);
    });

    test('Testing of getter and setter with int', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const int value = 1;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, null);
    });

    test('Testing of getter and setter with double', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const double value = 1.0;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, null);
    });


    test('Testing of with List<String> object', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final List<String> value = <String>['Hi', 'Hello'];
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, null);
    });

    test('Testing of basic getter and setter with complex object', () async {
      final TestModel githubTreeModel = TestModel(sha: key);
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      localStorageUtil.saveToDisk(key: key, value: githubTreeModel.toJson(), expiryInSecond: expiryTimeInSecond);
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      final dynamic result = localStorageUtil.getFromDisk(key);
      expect(result, null);
    });
  });

  group('To check the value has been deleted', () {
    const int expiryTimeInSecond = 1;
    test('Testing of getter and setter with String', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const String value = 'Hi';
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      expect(localStorageUtil.get(key), isNot(null));
      localStorageUtil.getFromDisk(key);
      expect(localStorageUtil.get(key), null);

    });

    test('Testing of getter and setter with bool', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const bool value = true;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      expect(localStorageUtil.get(key), isNot(null));
      localStorageUtil.getFromDisk(key);
      expect(localStorageUtil.get(key), null);
    });

    test('Testing of getter and setter with int', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const int value = 1;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      expect(localStorageUtil.get(key), isNot(null));
      localStorageUtil.getFromDisk(key);
      expect(localStorageUtil.get(key), null);
    });

    test('Testing of getter and setter with double', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      const double value = 1.0;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      expect(localStorageUtil.get(key), isNot(null));
      localStorageUtil.getFromDisk(key);
      expect(localStorageUtil.get(key), null);
    });


    test('Testing of with List<String> object', () async {
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final List<String> value = <String>['Hi', 'Hello'];
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      expect(localStorageUtil.get(key), isNot(null));
      localStorageUtil.getFromDisk(key);
      expect(localStorageUtil.get(key), null);
    });

    test('Testing of basic getter and setter with complex object', () async {
      final TestModel githubTreeModel = TestModel(sha: key);
      SharedPreferences.setMockInitialValues(initialValue);
      final LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      localStorageUtil.saveToDisk(key: key, value: githubTreeModel.toJson(), expiryInSecond: expiryTimeInSecond);
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      expect(localStorageUtil.get(key), isNot(null));
      localStorageUtil.getFromDisk(key);
      expect(localStorageUtil.get(key), null);
    });
  });


}