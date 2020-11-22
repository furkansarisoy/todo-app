import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  String errorMessage;
  AuthenticationService(this._firebaseAuth);
  User user;
  String email;
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      email = user.email;
      return "Signed in";
    } catch (error) {
      switch (error.code) {
        case "invalid-email":
        case "wrong-password":
          errorMessage = "E-mail veya şifreniz hatalı";
          break;
        case "user-not-found":
          errorMessage = "Böyle bir kullanıcı bulunamamakta";
          break;
        case "operation-not-allowed":
          errorMessage = "Server hatası,lütfen daha sonra tekrar deneyiniz.";
          break;

        default:
          errorMessage = "Beklenmeyen bir hata oluştu";
      }
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return user.uid;
  }

  Future<String> signUp({String email, String password}) async {
    User user;
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      user = result.user;
      email = user.email;
      return "Sign Up";
    } catch (error) {
      switch (error.code) {
        case "email-already-in-use":
          errorMessage = "Girdiğiniz e-mail kullanılıyor.";
          break;
        case "operation-not-allowed":
          errorMessage = "Server hatası, lütfen tekrar deneyiniz.";
          break;
        default:
          errorMessage = "Beklenmeyen bir hata oluştu";
      }
      if (errorMessage != null) {
        return Future.error(errorMessage);
      }

      return user.uid;
    }
  }

  Future<void> resetPassword({String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (error) {
      switch (error.code) {
        case "operation-not-allowed":
          errorMessage = "Server hatası , lütfen tekrar deneyiniz.";
          break;
        case "invalid-email":
        case "user-not-found":
          errorMessage = "Kayıtlı kullanıcı bulunamadı";
          break;
        default:
          errorMessage = "Beklenmeyen bir hata oluştu";
      }
      if (errorMessage != null) {
        return Future.error(errorMessage);
      }
    }
  }
}
