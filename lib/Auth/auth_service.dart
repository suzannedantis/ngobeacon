import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService{
  final SupabaseClient _supabase = Supabase.instance.client;

  // Redirect call
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'https://sites.google.com/view/ngobeacon-reset/home', // Your reset URL
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to send reset email');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user == null) {
        throw Exception('Password update failed');
      }
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to update password');
    }
  }

  //Sign in with email and password
  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async{
    return await _supabase.auth.signInWithPassword(
        email: email,
        password: password
    );

  }
  //Sign up with email and password
  Future<AuthResponse> signUpWithEmailAndPassword(String email, String password) async{
    return await _supabase.auth.signUp(
        email: email,
        password: password
    );


  }

  // Forgot Password
  Future<void> forgotPassword(String email) async{
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // Google native Sign in

  Future<AuthResponse> googleSignIn() async {
    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    const webClientId = 'my-web.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId = 'my-ios.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }


  //Sign out
  Future<void> signOut() async{
    await _supabase.auth.signOut();

  }
  // get email
  Future<String?> getCurrentUserEmail() async {
    final session = _supabase.auth.currentSession;
    final user  = session?.user;
    return user?.email;
  }






}