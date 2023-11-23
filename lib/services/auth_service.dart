import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

//Google sign in
  signInWithGoogle() async {
    //begin interactive sign in procces
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtaiin auth details from request 
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for user
    final Credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //finally, lets Sign in
    return await FirebaseAuth.instance.signInWithCredential(Credential);
  }
}