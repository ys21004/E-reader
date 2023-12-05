// auth_utils.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthUtils {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> sendEmailVerification(
      String email, FirebaseAuth auth) async {
    // Implement the logic to send an email verification link
    // Use the provided email to send the link
    // Remember to replace 'https://www.example.com/finishSignUp?cartId=1234' with your deep link
    ActionCodeSettings acs = ActionCodeSettings(
      url: 'https://www.example.com/finishSignUp?cartId=1234',
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.android',
      androidInstallApp: true,
      androidMinimumVersion: '12',
    );

    try {
      await auth.sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
      print('Successfully sent email verification');
    } catch (error) {
      print('Error sending email verification $error');
    }
  }

  static Future<void> completeSignInWithEmailLink(
      String email, String emailLink, FirebaseAuth) async {
    // Confirm the link is a sign-in with email link.
    if (auth.isSignInWithEmailLink(emailLink)) {
      try {
        // The client SDK will parse the code from the link for you.
        UserCredential userCredential = await auth.signInWithEmailLink(
          email: email,
          emailLink: emailLink,
        );

        // You can access the new user via userCredential.user.
        String? emailAddress = userCredential.user?.email;

        print('Successfully signed in with email link!');
      } catch (error) {
        print('Error signing in with email link: $error');
      }
    }
  }
}
