import 'package:flutter/widgets.dart';
import 'package:nextq_app/model/profile.dart';
import 'package:nextq_app/services/firebase_auth_service.dart';
import 'package:nextq_app/ui/static/firebase_auth_status.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  // todo-02-provider-04: inject a firebase auth service
  final FirebaseAuthService _service;

  FirebaseAuthProvider(this._service);

  // todo-02-provider-05: add state to check loading in every process and profile user
  String? _message;
  Profile? _profile;
  FirebaseAuthStatus _authStatus = FirebaseAuthStatus.unauthenticated;

  Profile? get profile => _profile;
  String? get message => _message;
  FirebaseAuthStatus get authStatus => _authStatus;

  // todo-02-provider-06: add a function to create an account
  Future createAccount(
      String email, String password, String displayName) async {
    try {
      _authStatus = FirebaseAuthStatus.creatingAccount;
      notifyListeners();

      await _service.createUser(email, password, displayName);

      final user = await _service.userChanges();
      _profile = Profile(
        name: user?.displayName,
        email: user?.email,
        photoUrl: user?.photoURL,
      );

      _authStatus = FirebaseAuthStatus.accountCreated;
      _message = "Create account is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }

  // todo-02-provider-07: add a function to login
  Future signInUser(String email, String password) async {
    try {
      _authStatus = FirebaseAuthStatus.authenticating;
      notifyListeners();

      final result = await _service.signInUser(email, password);

      _profile = Profile(
        name: result.user?.displayName,
        email: result.user?.email,
        photoUrl: result.user?.photoURL,
      );

      _authStatus = FirebaseAuthStatus.authenticated;
      _message = "Sign in is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }

  // todo-02-provider-08: add a function to logout
  Future signOutUser() async {
    try {
      _authStatus = FirebaseAuthStatus.signingOut;
      notifyListeners();

      await _service.signOut();

      _authStatus = FirebaseAuthStatus.unauthenticated;
      _message = "Sign out is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }

  // todo-02-provider-09: update the profile when still login
  Future updateProfile() async {
    final user = await _service.userChanges();
    _profile = Profile(
      name: user?.displayName,
      email: user?.email,
      photoUrl: user?.photoURL,
    );
    notifyListeners();
  }
}
