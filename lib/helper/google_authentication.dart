import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_together/usecase/user.dart';
import 'package:go_together/widgets/screens/login/user_info_google.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final UserUseCase userUseCase = UserUseCase();

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final String? token = googleSignInAuthentication.idToken;

        debugPrint('token : $token');

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;

          // ********* GENERATE TOKEN JWT

          // Nous récupérons le use case de l'user
          // Le usecase permet de lister toutes les fonctions que
          // l'utilisateur peut faire

          final UserUseCase userUseCase = UserUseCase();

          debugPrint('user: $user');

          if(user != null) {
            // Nous récupérons le token de l'utilisateur quand il appuie
            // sur le bouton de connexion
            String idToken = await user.getIdToken();
            debugPrint('idToken: $idToken');
            // Nous appelons la fonction pour récupérer le token JWT généré par
            // l'API en Flask
            String tokenGoogleJWT = await userUseCase
                .getJWTTokenByGoogleToken(idToken);
            debugPrint('tokenJWT: $tokenGoogleJWT');
          }

          // ************************************
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              GoogleAuthentication.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              GoogleAuthentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            GoogleAuthentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserInfoScreen(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        GoogleAuthentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
