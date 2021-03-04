import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _errorMessage = "";

  final _formKey = GlobalKey<FormState>();

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult = await facebookLogin.logIn(['email']);
    print(facebookLoginResult.status.toString());
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");

        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        final FacebookAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
                facebookLoginResult.accessToken.token);
        await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        break;
    }
  }

  void login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('SSAD Game',
              style: TextStyle(fontFamily: 'Orbitron', fontSize: 35)),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty || val == null)
                          return 'Email cannot be empty!';
                        return null;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty || val == null)
                          return 'Password cannot be empty!';
                        return null;
                      },
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
                Text(_errorMessage),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text('Login'),
                      onPressed: () {
                        print(_emailController.text);
                        print(_passwordController.text);
                        if (_formKey.currentState.validate()) {
                          login();
                        }
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      child: Text('Register'),
                      onPressed: () {
                        print(_emailController.text);
                        print(_passwordController.text);
                        if (_formKey.currentState.validate()) {
                          register();
                        }
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  child: Text('Login with Facebook'),
                  onPressed: () {
                    initiateFacebookLogin();
                  },
                ),
              ],
            ),
          )

          // FACEBOOK BUTTON HERE
        ],
      )),
    );
  }
}
