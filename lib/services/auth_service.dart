import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Custom exception kapag hindi CvSU email ang ginamit sa Google Sign-In.
class GoogleDomainException implements Exception {
  final String message;
  GoogleDomainException(this.message);

  @override
  String toString() => message;
}

/// Service para sa Authentication — gumagamit ng Firebase Auth kasama ang
/// Google Sign-In, naka-restrict lang sa mga may @cvsu.edu.ph na email.
class AuthService {
  static const String _allowedDomain = 'cvsu.edu.ph';

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    hostedDomain: _allowedDomain, // hint lang sa account picker; hindi ito security
  );
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream na "nakikinig" sa kasalukuyang login state — ginagamit ito ng
  /// main.dart para malaman kung dapat ipakita ang LoginScreen o ang
  /// CodeEditorScreen.
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static User? get currentUser => _auth.currentUser;

  /// Nagpapasimula ng buong Google Sign-In + Firebase Auth flow.
  /// - Returns null kung kinansela ng user ang sign-in.
  /// - Nagta-throw ng [GoogleDomainException] kung hindi CvSU email.
  static Future<User?> signInWithGoogle() async {
    final googleAccount = await _googleSignIn.signIn();

    if (googleAccount == null) {
      // kinansela ng user ang sign-in (pinindot ang "back" sa picker)
      return null;
    }

    // I-check muna ang domain BAGO pa natin ituloy ang Firebase sign-in —
    // mas mabilis at mas malinaw kaysa hintayin pa ang buong flow.
    if (!googleAccount.email.toLowerCase().endsWith('@$_allowedDomain')) {
      await _googleSignIn.signOut();
      throw GoogleDomainException(
        'Kailangan gumamit ng school email (@$_allowedDomain).',
      );
    }

    final googleAuth = await googleAccount.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      await _createOrUpdateUserRecord(user);
    }

    return user;
  }

  /// Ise-save/i-a-update ang basic info ng user sa Firestore — dito
  /// natin ilalagay ang "database" na parte ng system (mga bagay
  /// tulad ng pangalan, email, at petsa ng huling login).
  static Future<void> _createOrUpdateUserRecord(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    // Dati, sa bawat login ay nao-overwrite ang createdAt. Ngayon, itinatakda
    // lang ito kapag bagong user (wala pang document).
    final existing = await userDoc.get();

    await userDoc.set({
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'lastLoginAt': FieldValue.serverTimestamp(),
      if (!existing.exists) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
