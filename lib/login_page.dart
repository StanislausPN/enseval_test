import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_enseval/home_page.dart';

enum LoginStatus { noSignIn, signIn }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  LoginStatus _loginStatus = LoginStatus.noSignIn;

  String _emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Format email tidak sesuai!';
    } else if (value.length > 15) {
      return "Email lebih dari 15 karakter";
    } else if (value.length < 10) {
      return "Email kurang dari 10 karakter";
    } else if (value.isEmpty) {
      return "Email kosong";
    } else {
      return null;
    }
  }

  String _passwordValidator(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Format password tidak sesuai!';
    } else if (value.isEmpty) {
      return "Password kosong";
    } else if (value.length < 8) {
      return "Passwod kurang dari 8 karakter";
    } else {
      return null;
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      // if (emailController.value.text == emailKu &&
      //     passController.value.text == passKu) {
      form.save();
      _login();
      // } else {
      // }
    }
  }

  _login() {
    String email = emailController.value.text;
    setState(() {
      _loginStatus = LoginStatus.signIn;
      savePref(value, email);
    });
  }

  _signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.noSignIn;
    });
  }

// michael@emos.id
  savePref(int value, String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("email", email);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.noSignIn;
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    switch (_loginStatus) {
      case LoginStatus.noSignIn:
        return Scaffold(
          backgroundColor: Colors.blueAccent,
          body: Center(
            child: Container(
              width: screenWidth - 100,
              height: screenHeight / 2.5,
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          key: _key,
                          child: Column(
                            children: [
                              TextFormField(
                                  controller: emailController,
                                  validator: _emailValidator,
                                  decoration:
                                      InputDecoration(labelText: "Email")),
                              TextFormField(
                                  controller: passController,
                                  obscureText: true,
                                  validator: _passwordValidator,
                                  decoration:
                                      InputDecoration(labelText: "Password")),
                            ],
                          )),
                    ),
                    RaisedButton(
                        child: Text('Login'),
                        onPressed: () {
                          check();
                          print(_loginStatus);
                          
                        }),
                        SelectableText('Valid Password: !1Sa^8Bc')
                  ],
                ),
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return HomePage(
          signOut: _signOut,
        );
        break;
    }
    return Scaffold(
      appBar: AppBar(
          title: Text('Login View'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Center(
        child: Text('LOGIN VIEW'),
      ),
    );
  }
}
