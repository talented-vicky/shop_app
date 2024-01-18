import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/exception.dart';

class Auth with ChangeNotifier {
  dynamic _token;
  DateTime? _expiryDate;
  dynamic _userId;
  Timer? _authClock;

  bool get isAuth {
    if (fetchToken == null) {
      return false;
    }
    return true;
  }

  get fetchToken {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  get fetchUserId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String linkTrim) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$linkTrim?key=AIzaSyC1PC7YP6exdPbOJOw2y6phBi_pIoXhan4');

    try {
      final resp = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final result = json.decode(resp.body);
      if (result['error'] != null) {
        throw Exceptions(msg: result['error']['message']);
        // 'cos I throw this exception, I can show users error on
        // the frontend
      }

      // there's no error, hence store user's details
      _token = result['idToken'];
      _userId = result['localId'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(result['expiresIn']),
      ));

      _autoLogout();
      notifyListeners();

      // Loads and parses the [SharedPreferences] for this app from disk.
      final sharedPred = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId,
        'token': _token,
        'expiryDate': _expiryDate!.toIso8601String()
      });

      await sharedPred.setString('userData', userData);
    } catch (err) {
      throw err;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> autoSignin() async {
    final sharedPref = await SharedPreferences.getInstance();

    // confirm if there's nothing stored in disk & return
    if (!sharedPref.containsKey('userData')) {
      return false;
    }

    final sharedPrefData =
        json.decode(sharedPref.getString('userData')!) as Map<String, dynamic>;
    final sharePrefExDate = DateTime.parse(sharedPrefData['expiryDate']);

    // token is expired
    if (sharePrefExDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = sharedPrefData['token'];
    _userId = sharedPrefData['userId'];
    _expiryDate = sharePrefExDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authClock != null) {
      _authClock!.cancel();
      _authClock = null;
    }

    notifyListeners();

    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.clear();
  }

  void _autoLogout() {
    if (_authClock != null) {
      _authClock!.cancel();
      // canceling timer if there's already one ongoing
    }
    final expTime = _expiryDate!.difference(DateTime.now()).inSeconds;
    // calling logOut function after "expTime" seconds
    _authClock = Timer(Duration(seconds: expTime), logOut);
  }
}
