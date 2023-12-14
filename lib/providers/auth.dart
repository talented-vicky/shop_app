import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  // String _token;
  // DateTime _expiryDate;
  // String _userId;

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse('');

    try {
      final resp = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureTok': true,
          }));
      json.decode(resp.body);
    } catch (err) {
      throw err;
    }
  }
}
