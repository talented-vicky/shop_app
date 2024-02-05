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
        body: SingleChildScrollView(
      child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                child: Column(
              children: [
                Container(
                  child: const Icon(Icons.supervised_user_circle_outlined,
                      size: 120, color: Colors.grey),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: const Text("ShopApp",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            letterSpacing: 3,
                            fontFamily: 'Anton'))),
              ],
            )),
            Flexible(
                flex: deviceSize.width > 600 ? 2 : 1, child: const AuthWidget())
          ])),
    ));
  }
}

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> with TickerProviderStateMixin {
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
  late AnimationController _animeCtrl;
  late Animation<Size> _animeHeight;
  late Animation<double> _opacity;

  @override
  void initState() {
    _animeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animeHeight = Tween<Size>(
      begin: const Size(double.infinity, 260),
      end: const Size(double.infinity, 320),
    ).animate(CurvedAnimation(
      parent: _animeCtrl,
      curve: Curves.easeIn,
    ));
    _opacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animeCtrl,
      curve: Curves.easeIn,
    ));

    // triggering the build method so we
    // _animeHeight.addListener(() => setState(() {}));
    // I used animatedBuilder() so I don't need to manually
    // call build anymore
    super.initState();
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    // _animeCtrl.dispose();
    super.dispose();
  }

  void _swithAuthState() {
    if (_authstate == AuthState.logIn) {
      setState(() => _authstate = AuthState.signUp);
      // // now we trigger/start the animation
      _animeCtrl.forward();
    } else {
      setState(() => _authstate = AuthState.logIn);
      _animeCtrl.reverse();
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
    return Container(
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            // animation: _animeHeight,
            // builder: (ctxt, ch) => Container(
            // height: _animeHeight.value.height,
            height: _authstate == AuthState.signUp ? 320 : 260,
            constraints: BoxConstraints(
                // minHeight: _animeHeight.value.height),
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
                    const SizedBox(height: 10),
                    // if (_authstate == AuthState.signUp)
                    FadeTransition(
                      opacity: _opacity,
                      child: TextFormField(
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
                    ),
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
