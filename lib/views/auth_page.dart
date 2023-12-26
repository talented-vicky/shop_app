import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/exception.dart';

enum AuthState { signUp, logIn }

class AuthPage extends StatelessWidget {
  static const routeName = '/auth';

  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(children: [
      Container(
          decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              const Color.fromRGBO(215, 117, 255, 1).withOpacity(.5),
              const Color.fromRGBO(255, 188, 117, 1).withOpacity(.9)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 1]),
      )),
      SingleChildScrollView(
        child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.deepOrange.shade900,
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 8,
                                color: Colors.black,
                                offset: Offset(0, 2))
                          ]),
                      child: const Text("ShopApp",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'Anton')))),
              Flexible(
                  flex: deviceSize.width > 600 ? 2 : 1,
                  child: const AuthWidget())
            ])),
      )
    ]));
  }
}

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  // gives me access to the state of the form in this widget

  AuthState _authstate = AuthState.logIn;

  // Map<String, String> _authInfo = {
  final Map<String, String> _authInfo = {
    'email': '',
    'password': '',
  };

  bool _isLoading = false;
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _swithAuthState() {
    if (_authstate == AuthState.logIn) {
      setState(() => _authstate = AuthState.signUp);
    } else {
      setState(() => _authstate = AuthState.logIn);
    }
  }

  void _showError(String msg) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Error Occured!'),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(context),
                    child: const Text('Okay'))
              ],
            ));
  }

  Future<void> _signUser() async {
    if (!_formkey.currentState!.validate()) {
      // hence error occured validating
      return;
    }
    _formkey.currentState!.save();
    // saving all my input fields

    setState(() => _isLoading = true);
    // I show a loading inidiator imediately I click save

    try {
      if (_authstate == AuthState.logIn) {
        await Provider.of<Auth>(context, listen: false)
            .logIn(_authInfo['email']!, _authInfo['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authInfo['email']!, _authInfo['password']!);
      }
    } on Exceptions catch (customErr) {
      // customErr is what I'm catching from the auth provider
      // error handler
      var newError = 'Authentication Error';
      if (customErr.toString() == 'EMAIL_EXISTS') {
        newError = "Email already exists, please login";
      } else if (customErr.toString() == 'INVALID_LOGIN_CREDENTIALS') {
        newError = 'No Email In Database OR Email/Password incorrect';
      }
      _showError(newError);
    } catch (err) {
      const error = 'ERROR! Please try again OR check internet connection ';
      _showError(error);
    }
    setState(() => _isLoading = false);
    // remove spinner since I'm done signing up/in
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        child: Container(
            height: _authstate == AuthState.signUp ? 320 : 260,
            constraints: BoxConstraints(
                minHeight: _authstate == AuthState.signUp ? 320 : 260),
            width: deviceSize.width * .75,
            padding: const EdgeInsets.all(12),
            child: Form(
                key: _formkey,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val!.isEmpty || !val.contains('@')) {
                          return 'Invalid Email';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _authInfo['email'] = val!;
                      },
                    ),
                    TextFormField(
                      obscureText: true, // asteriks thingy
                      decoration: const InputDecoration(labelText: 'Password'),
                      controller: _passwordCtrl,
                      validator: (val) {
                        if (val!.isEmpty || val.length <= 8) {
                          return 'Password must be at least 8 char';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _authInfo['password'] = val!;
                      },
                    ),
                    if (_authstate == AuthState.signUp)
                      TextFormField(
                          enabled: _authstate == AuthState.signUp,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Confrim Password'),
                          validator: _authstate == AuthState.signUp
                              ? (val) {
                                  if (val != _passwordCtrl.text) {
                                    return 'Passwords do not match';
                                  }
                                }
                              : null),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: _signUser,
                        child: Text(_authstate == AuthState.signUp
                            ? 'SIGN UP'
                            : 'LOGIN'),
                        // style: ButtonStyle(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                            '${_authstate == AuthState.logIn ? 'Dont' : 'Already'} have an account?'),
                        TextButton(
                          onPressed: _swithAuthState,
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                              '${_authstate == AuthState.logIn ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                        ),
                      ],
                    )
                  ],
                )))));
  }
}
