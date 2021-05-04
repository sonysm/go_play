import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Future<String> authenticate({
    required String phone,
    required String password,
  }) async {
    //String refreshToken = await TmsService().login(phone, password);
    await Future.delayed(Duration(seconds: 1));
    return 'refreshToken';
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_token');
    // await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_token', token);
    return;
  }

  Future<String?> fetchToken() async {
    /// get token from keystore/keychain
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
    /// delete user preference from keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_prefs');
    return;
  }

  Future<void> persistUserPrefs(String userPrefs) async {
    /// write user preference to keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_prefs', userPrefs);
    return;
  }

  Future<void> persistHeaderToken(String token) async {
    /// write to keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('header_token', token);
    return;
  }

  Future<String?> fetchHeaderToken() async {
    /// write to keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('header_token');
    return token;
  }

  Future<void> deleteHeaderToken() async {
    /// delete from keystore/keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('header_token');
    return;
  }
}