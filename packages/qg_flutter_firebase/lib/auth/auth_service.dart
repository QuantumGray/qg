import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/base/base.dart';
import 'package:qg_flutter_base/base/request_response.dart';

// appUserStream (userauthevents + userdatachangeevents)
// authenticate (login + register) -> google, phone, email + password, email link
// userdata (get + set)
// delete
// userconfig provider ? keys, select, parser function etc. global function overrideFirebaseConfig()

final pFirebaseConfig =
    Provider<FirebaseUserConfig>((ref) => throw UnimplementedError());

class Firebase extends StatefulWidget {
  final Widget child;
  final FirebaseUserConfig userConfig;
  const Firebase({
    Key? key,
    required this.child,
    required this.userConfig,
  }) : super(key: key);

  @override
  _FirebaseState createState() => _FirebaseState();
}

class _FirebaseState extends State<Firebase> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        pFirebaseConfig.overrideWithValue(
          widget.userConfig,
        ),
      ],
      child: widget.child,
    );
  }
}

class FirebaseUserConfig<U extends BaseFirebaseUser> {
  final CollectionReference userCollection;
  final U Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(U user) toJson;
  final U Function(User user) fromFirebaseUser;

  FirebaseUserConfig({
    required this.userCollection,
    required this.fromJson,
    required this.toJson,
    required this.fromFirebaseUser,
  });
}

abstract class BaseFirebaseUser {
  String get uid;
  String get ref;

  BaseFirebaseUser copyWithRef(String ref);
}

final Provider<FirebaseAuthRepository> pAuthRepository =
    Provider<FirebaseAuthRepository>(
  (ref) => FirebaseAuthRepository(
    ref.read,
    ref.watch(pFirebaseConfig),
  ),
);

class FirebaseAuthRepository<U extends BaseFirebaseUser>
    extends BaseRepository {
  final FirebaseUserConfig config;

  FirebaseAuthRepository(Reader read, this.config) : super(read);

  final _auth = FirebaseAuth.instance;

  void logout() {
    if (_auth.currentUser != null) {
      _auth.signOut();
    }
  }

  Stream<U?> get userStream => authStateChanges.asyncMap(
        (firebaseUser) async {
          try {
            if (firebaseUser == null) {
              return null;
            }
            final availableUser = (await findUser(firebaseUser.uid))
                .whenOrNull(data: (user) => user);
            if (availableUser != null) {
              return availableUser;
            }
            final newUser = _appUserFromFirebaseUser(firebaseUser);
            return (await storeNewUser(newUser)).when<U>(
              data: (user) => user,
              error: (error, trace) {
                throw Exception();
              },
            );
          } on Exception catch (e) {
            throw Exception();
          }
        },
      );

  U _appUserFromFirebaseUser(User firebaseUser) =>
      config.fromFirebaseUser(firebaseUser) as U;

  CollectionReference get users => config.userCollection;

  Future<RequestResponse<U>> storeNewUser(U user) => RequestResponse.guard(
        () async {
          try {
            final ref = await users.add(config.toJson(user));
            final updatedUser = user.copyWithRef(ref.path);
            await ref.set(config.toJson(updatedUser));
            return updatedUser as U;
          } on Exception catch (e) {
            throw Exception();
          }
        },
      );

  Future<RequestResponse<U?>> findUser(String uid) =>
      RequestResponse.guard(() async {
        try {
          final snapshot = await users.where('uid', isEqualTo: uid).get();

          if (snapshot.docs.isNotEmpty) {
            final json = snapshot.docs.single.data();
            if (json == null) {
              throw NullThrownError();
            }
            return config.fromJson(json as Map<String, dynamic>) as U;
          } else {
            return null;
          }
        } on Exception catch (e) {
          throw Exception(e);
        }
      });

  @override
  Stream<User?> get authStateChanges =>
      _auth.authStateChanges().asyncMap((user) => user);

  @override
  // ignore: missing_return
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (error) {
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // @override
  // Future<User?> signInWithApple() {
  //   // TODO: implement signInWithApple
  //   throw UnimplementedError();
  // }

  // @override
  // Future<User?> verifyPhoneNumber({
  //   required String phoneNumber,
  //   required VoidCallback verificationCompleted,
  //   required VoidCallback verificationFailed,
  //   required VoidCallback codeSent,
  //   required VoidCallback codeAutoRetrievalTimeout,
  // }) async {
  //   UserCredential? userCredential;
  //   try {
  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         try {
  //           userCredential = await _auth.signInWithCredential(credential);
  //         } catch (e) {
  //           // ignore: avoid_print
  //           print(e);
  //         } finally {
  //           if (userCredential != null) verificationCompleted();
  //         }
  //       },
  //       verificationFailed: (FirebaseAuthException error) {
  //         verificationFailed();
  //         throw VerifyPhoneNumberException(
  //           error: error,
  //           firebaseAuth: _auth,
  //         );
  //       },
  //       codeSent: (String verificationId, int? resendToken) async {
  //         codeSent();
  //         try {
  //           await read(pPinCode).future.then((smsCode) async {
  //             final PhoneAuthCredential credential =
  //                 PhoneAuthProvider.credential(
  //               verificationId: verificationId,
  //               smsCode: smsCode,
  //             );
  //             final User? _currentUser = getCurrentUser();
  //             _currentUser == null
  //                 ? userCredential =
  //                     await _auth.signInWithCredential(credential)
  //                 : userCredential =
  //                     await _currentUser.linkWithCredential(credential);
  //           });
  //         } catch (e) {
  //           // ignore: avoid_print
  //           print(e);
  //         } finally {
  //           if (userCredential != null) verificationCompleted();
  //         }
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         codeAutoRetrievalTimeout();
  //       },
  //     );
  //     return userCredential!.user;
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //     throw UnimplementedError();
  //   }
  // }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      final providerId = _auth.currentUser?.providerData.first.providerId;

      switch (providerId) {
        // case 'apple.com':
        //   await signInWithApple();
        //   break;
        case 'google.com':
          await signInWithGoogle();
          break;
        default:
      }
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}

final pUser = StateProvider(
  (ref) {
    final user = ref.watch(pUserStream).asData?.value;
    return user;
  },
);

final pUserChangesStream = StreamProvider(
  (ref) => ref
      .read(pUserStream.stream)
      .distinct((previousUser, newUser) => previousUser?.uid == newUser?.uid),
);

final pUserFirebaseStream = StreamProvider(
  (ref) => ref.read(pAuthRepository).userStream,
);

final pUserStream = StreamProvider((ref) {
  return ref.read(pUserFirebaseStream.stream).flatMap((user) {
    return MergeStream(
      [
        ref.read(pUserFirebaseStream.stream).shareValue(),
        if (user != null)
          FirebaseFirestore.instance.doc(user.ref).snapshots().map((snapshot) =>
              ref.read(pFirebaseConfig).fromJson(snapshot.data()!)),
      ],
    );
  });
});
