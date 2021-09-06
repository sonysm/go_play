import 'dart:convert';

import 'package:kroma_sport/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_token');
    return;
  }

  Future<void> persistToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_token', token);
    return;
  }

  Future<String?> fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user_token');
    return token;
  }

  //Future<bool> hasToken() async {
  //  /// read from keystore/keychain
  //  SharedPreferences prefs = await SharedPreferences.getInstance();
  //  if (prefs != null && prefs.containsKey('user_token')) {
  //    return true;
  //  }

  //  // await Future.delayed(Duration(seconds: 2));
  //  return false;
  //}

  Future<void> deleteUserPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_prefs');
    return;
  }

  Future<void> persistUserPrefs(String userPrefs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_prefs', userPrefs);
    return;
  }

  Future<User> fetchUserPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user_prefs');
    return User.fromJson(jsonDecode(user!));
  }

  Future<void> persistHeaderToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('header_token', token);
    return;
  }

  Future<String?> fetchHeaderToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('header_token');
    return token;
  }

  Future<void> deleteHeaderToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('header_token');
    return;
  }
}
