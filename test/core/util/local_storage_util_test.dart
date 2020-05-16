
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_viewer/core/util/local_storage_util.dart';
import 'package:git_viewer/data/models/git_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  group('without expiry time', () {
    String key = "1";
    test('Testing of getter and setter with String', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = "Hi";
      localStorageUtil.saveToDisk(key: key, value: value);
      final result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of getter and setter with bool', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = true;
      localStorageUtil.saveToDisk(key: key, value: value);
      final result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of getter and setter with int', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = 1;
      localStorageUtil.saveToDisk(key: key, value: value);
      final result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of getter and setter with double', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = 1.0;
      localStorageUtil.saveToDisk(key: key, value: value);
      final result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of with List<int> object', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = [1, 2];
      localStorageUtil.saveToDisk(key: key, value: value);
      final result = localStorageUtil.getFromDisk(key);
      print(result);
      expect(result, value);
    });

    test('Testing of with List<String> object', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = ["Hi", "Hello"];
      localStorageUtil.saveToDisk(key: key, value: value);
      final result = localStorageUtil.getFromDisk(key);
      print(result);
      expect(result, value);
    });

    test('Testing of basic getter and setter with complex object', () async {
      GithubTreeModel githubTreeModel = GithubTreeModel(sha: key);
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      localStorageUtil.saveToDisk(key: key, value: githubTreeModel.toJson());
      final result = GithubTreeModel.fromJson(
          localStorageUtil.getFromDisk(key));
      expect(result, githubTreeModel);
    });

    test('Testing of basic getter and setter with List<complex object>', () async {
      GithubTreeModel githubTreeModel = GithubTreeModel(sha: key);
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      localStorageUtil.saveToDisk(key: key, value: [githubTreeModel.toJson()]);
      final result = localStorageUtil.getFromDisk(key);
      expect(result, [githubTreeModel.toJson()]);
    });

  });

  group('with expiry time = 10 sec and object has not expired yet', () {
    String key = "1";
    int expiryTimeInSecond = 10;
    test('Testing of getter and setter with String', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = "Hi";
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      final result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of getter and setter with bool', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = true;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      final result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of getter and setter with int', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = 1;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      final result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of getter and setter with double', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = 1.0;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      final result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });


    test('Testing of with List<String> object', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = ["Hi", "Hello"];
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      final result = localStorageUtil.getFromDisk(key);
      expect(result, value);
    });

    test('Testing of basic getter and setter with complex object', () async {
      GithubTreeModel githubTreeModel = GithubTreeModel(sha: key);
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      localStorageUtil.saveToDisk(key: key, value: githubTreeModel.toJson(), expiryInSecond: expiryTimeInSecond);
      final result = GithubTreeModel.fromJson(
          localStorageUtil.getFromDisk(key));
      expect(result, githubTreeModel);
    });

    test('Testing of basic getter and setter with List<complex object>', () async {
      GithubTreeModel githubTreeModel = GithubTreeModel(sha: key);
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      localStorageUtil.saveToDisk(key: key, value: [githubTreeModel.toJson()], expiryInSecond: expiryTimeInSecond);
      final result = localStorageUtil.getFromDisk(key);
      expect(result, [githubTreeModel.toJson()]);
    });
  });


  group('with expiry time = 1 sec and object has been expired yet', () {
    String key = "1";
    int expiryTimeInSecond = 1;
    test('Testing of getter and setter with String', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = "Hi";
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future.delayed(Duration(seconds: 1));
      final result = localStorageUtil.getFromDisk(key);
      expect(result, null);
    });

    test('Testing of getter and setter with bool', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = true;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future.delayed(Duration(seconds: 1));
      final result = localStorageUtil.getFromDisk(key);
      expect(result, null);
    });

    test('Testing of getter and setter with int', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = 1;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future.delayed(Duration(seconds: 1));
      final result = localStorageUtil.getFromDisk(key);
      expect(result, null);
    });

    test('Testing of getter and setter with double', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = 1.0;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future.delayed(Duration(seconds: 1));
      final result = localStorageUtil.getFromDisk(key);
      expect(result, null);
    });


    test('Testing of with List<String> object', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = ["Hi", "Hello"];
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future.delayed(Duration(seconds: 1));
      final result = localStorageUtil.getFromDisk(key);
      expect(result, null);
    });

    test('Testing of basic getter and setter with complex object', () async {
      GithubTreeModel githubTreeModel = GithubTreeModel(sha: key);
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      localStorageUtil.saveToDisk(key: key, value: githubTreeModel.toJson(), expiryInSecond: expiryTimeInSecond);
      await Future.delayed(Duration(seconds: 1));
      final result = localStorageUtil.getFromDisk(key);
      expect(result, null);
    });
  });

  group('To check the value has been deleted', () {
    String key = "1";
    int expiryTimeInSecond = 1;
    test('Testing of getter and setter with String', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = "Hi";
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future.delayed(Duration(seconds: 1));
      expect(localStorageUtil.get(key), isNot(null));
      localStorageUtil.getFromDisk(key);
      expect(localStorageUtil.get(key), null);

    });

    test('Testing of getter and setter with bool', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = true;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future.delayed(Duration(seconds: 1));
      expect(localStorageUtil.get(key), isNot(null));
      localStorageUtil.getFromDisk(key);
      expect(localStorageUtil.get(key), null);
    });

    test('Testing of getter and setter with int', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = 1;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future.delayed(Duration(seconds: 1));
      expect(localStorageUtil.get(key), isNot(null));
      localStorageUtil.getFromDisk(key);
      expect(localStorageUtil.get(key), null);
    });

    test('Testing of getter and setter with double', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = 1.0;
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future.delayed(Duration(seconds: 1));
      expect(localStorageUtil.get(key), isNot(null));
      localStorageUtil.getFromDisk(key);
      expect(localStorageUtil.get(key), null);
    });


    test('Testing of with List<String> object', () async {
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      final value = ["Hi", "Hello"];
      localStorageUtil.saveToDisk(key: key, value: value, expiryInSecond: expiryTimeInSecond);
      await Future.delayed(Duration(seconds: 1));
      expect(localStorageUtil.get(key), isNot(null));
      localStorageUtil.getFromDisk(key);
      expect(localStorageUtil.get(key), null);
    });

    test('Testing of basic getter and setter with complex object', () async {
      GithubTreeModel githubTreeModel = GithubTreeModel(sha: key);
      SharedPreferences.setMockInitialValues({});
      LocalStorageUtil localStorageUtil = await LocalStorageUtil.getInstance();
      localStorageUtil.saveToDisk(key: key, value: githubTreeModel.toJson(), expiryInSecond: expiryTimeInSecond);
      await Future.delayed(Duration(seconds: 1));
      expect(localStorageUtil.get(key), isNot(null));
      localStorageUtil.getFromDisk(key);
      expect(localStorageUtil.get(key), null);
    });
  });


}