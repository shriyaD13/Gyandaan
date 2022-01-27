import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get uid {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _token != null &&
        _expiryDate!.isAfter(DateTime.now())) return _token;
    return null;
  }

  Future<void> signIn(String? email, String? password) async {
    final url = 'https://morning-scrubland-18150.herokuapp.com/signIn';
    try {
      final resp = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {"Content-Type": "application/json"},
      );
      final respData = json.decode(resp.body);
      print(respData);
      _token = respData['token'];
      _userId = respData['userId'];
      _expiryDate =
          DateTime.now().add(Duration(seconds: respData['expirationTime']));
      autoLogOut();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
      // print(json.decode(prefs.getString('userData')!));
    } catch (err) {
      throw err;
    }
  }

  Future<void> signUp(
      String? name, String? email, String? password, String? groupType) async {
    print(groupType);
    final url = 'https://morning-scrubland-18150.herokuapp.com/signUp';
    try {
      final resp = await http.post(
        Uri.parse(url),
        body: json.encode({
          'username': name,
          'email': email,
          'password': password,
          'type': groupType,
        }),
        headers: {"Content-Type": "application/json"},
      );
      final respData = json.decode(resp.body);
      print(respData);
      _token = respData['token'];
      _userId = respData['userId'];
      _expiryDate =
          DateTime.now().add(Duration(seconds: respData['expirationTime']));
      autoLogOut();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (err) {
      throw err;
    }
  }

 Future<void> logOut() async{
    _userId = null;
    _token = null;
    _expiryDate = null;
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final expiryTime = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expiryTime), logOut);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    print(expiryDate);
    if (expiryDate.isBefore(DateTime.now())) return false;  

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogOut();
    return true;
  }
}
