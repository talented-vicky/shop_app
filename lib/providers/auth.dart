import 'dart:convert';
// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  late DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    if (fetchToken == null) {
      return false;
    }
    return true;
  }

  dynamic get fetchToken {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
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
      notifyListeners();
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
}
