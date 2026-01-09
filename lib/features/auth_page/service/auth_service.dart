import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> ensureSignedIn() async {
    final user = _auth.currentUser;

    if (user != null) {
      return user;
    }

    final credential = await _auth.signInAnonymously();
    print('${credential.user}');
    return credential.user!;
  }

  User? get currentUser => _auth.currentUser;

  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;
}
