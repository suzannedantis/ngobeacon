/*
This file exists to maintain the authentication state

---------------------------------------------------------------
Authorized --> HomeScreen
UnAuthorized --> UserSignIn

*/

import '/login_page.dart';
import 'package:flutter/material.dart';
import '/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        //Check if there is a valid session currently
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          return HomePage(); // Path to the Home screen if logged in
        } else {
          return  LoginPage(); // To the Primary landing page then
        }
      },
    );
  }
}