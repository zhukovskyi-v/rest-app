import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../constants/constants.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated }

class AuthAPI extends ChangeNotifier {
  SupabaseClient supabaseClient = Supabase.instance.client;
  late final User account;

  late User _currentUser;

  AuthStatus _status = AuthStatus.uninitialized;

  // Getter methods
  User get currentUser => _currentUser;

  AuthStatus get status => _status;

  // Constructor
  AuthAPI() {
    loadUser();
  }

  loadUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user != null) {
      _status = AuthStatus.authenticated;
      _currentUser = user;
    } else {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: GOOGLE_WEB_CLIENT_ID,
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

      final session = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      if (session.user != null) {
      print("user here-> ${session.user?.id}");
        _currentUser = session.user!;
        _status = AuthStatus.authenticated;
      }
    } finally {
      notifyListeners();
    }
  }

  signInWithAnonymous() async {
    try {
      final session = await supabaseClient.auth.signInAnonymously();
      print('session: $session');
      if (session.user != null) {
        _currentUser = session.user!;
        _status = AuthStatus.authenticated;
      }
      return session;
    } finally {
      notifyListeners();
    }
  }

  signOut() async {
    try {
      await supabaseClient.auth.signOut();
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }
}
