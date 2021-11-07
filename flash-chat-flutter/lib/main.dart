import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

void main() => runApp(FlashChat());
/*
  Create a map of named routes for transition
      https://flutter.dev/docs/cookbook/navigation/named-routes
  Navigate from one screen to another
      Navigator.pushNamed(context, name of the route);
  Animations can be created by using animation controller

  To allocate curved animations use CurvedAnimation Object

 */

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      theme: ThemeData.dark().copyWith(
//        textTheme: TextTheme(
//          body1: TextStyle(color: Colors.black54),
//        ),
//      ),
      home: WelcomeScreen(),
      initialRoute: '/welcome',
      routes: {
        ChatScreen.route: (context) => new ChatScreen(),
        LoginScreen.route: (context) => new LoginScreen(),
        RegistrationScreen.route: (context) => new RegistrationScreen(),
        WelcomeScreen.route: (context) => new WelcomeScreen()
      },
    );
  }
}
