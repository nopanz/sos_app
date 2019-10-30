import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_app/sos.dart';
// import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = new GlobalKey<FormState>();
  SharedPreferences prefs;

  String _username;
  String _password;

  bool _isLoading;
  bool _autoValidate;

  @override
  void initState() {
    _isLoading = false;
    _autoValidate = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: ListView(
            children: [
              _showLogo(),
              _showUsernameInput(),
              _showPasswordInput(),
              _showLoginBtn()
            ],
          ),
        ),
      ),
    );
  }

  Widget _showLogo() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: SizedBox(
          height: 200,
          child: Hero(
            tag: 'logo_sos',
            child: Image.asset(
              'images/logo.png',
            ),
          ),
        ));
  }

  Widget _showUsernameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        autocorrect: false,
        onSaved: (value) => _username = value,
        decoration: InputDecoration(
            hintText: 'Username',
            labelText: 'Username',
            icon: Icon(
              Icons.account_box,
            )),
        validator: (val) => val.isEmpty ? 'Password can\`t be empty' : null,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        autocorrect: false,
        validator: (value) {
          if (value.isEmpty) {
            return 'Username can\`t be empty';
          }
          return null;
        },
        onSaved: (value) => _password = value,
        decoration: InputDecoration(
            hintText: 'Password',
            labelText: 'Password',
            icon: Icon(
              Icons.lock,
            )),
      ),
    );
  }

  Widget _showLoginBtn() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: RaisedButton(
          color: Color.fromRGBO(192, 57, 43, 1.0),
          onPressed: () {
            FormState form = _formKey.currentState;
            if (form.validate()) {
              form.save();
              setState(() => _isLoading = true);
            } else {
              setState(() => _autoValidate = true);
            }
            _login(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: !_isLoading ? _loginText() : CircularProgressIndicator(),
          ),
        ));
  }

  Future _login(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    if (_username == 'user' && _password == 'password') {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => SosScreen(),
          ));
    } else {
      setState(() => _isLoading = false);
      showDialog(
          context: context,
          builder: (BuildContext contex) {
            return AlertDialog(
              title: Text('Login Error'),
              content: Text('Invalid Credentials'),
            );
          });
    }
  }

  Widget _loginText() {
    return Text(
      'Login',
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
