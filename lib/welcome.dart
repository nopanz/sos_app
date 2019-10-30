import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_app/login.dart';

class WelcomeScreen extends StatelessWidget {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  Widget build(BuildContext context) {
    _authCheck(context);
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: SizedBox(
            height: 150,
            child: Hero(
              tag: 'logo_sos',
              child: Image.asset(
                'images/logo.png',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _authCheck(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => LoginScreen(),
            transitionDuration: Duration(seconds: 2),
            transitionsBuilder: (context, animation1, animation2, child) {
              return FadeTransition(
                opacity: animation1,
                child: child,
              );
            }));
  }
}
