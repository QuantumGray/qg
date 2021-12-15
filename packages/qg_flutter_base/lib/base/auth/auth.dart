// import 'package:jose/jose.dart';

// class Auth {
//   final String callbackUri;
//   Auth({
//     required this.callbackUri,
//   });

//   //final storage = FlutterSecureStorage();
//   final tokenKey = 'token';

//   Future<void> storeToken(String token) async {
//     await storage.write(key: tokenKey, value: token);
//   }

//   Future<String?> getToken() => storage.read(key: tokenKey);

//   Future<void> deleteToken() => storage.delete(key: tokenKey);
// }

// class AuthServerConnector {
//   final Auth auth;

//   AuthServerConnector(this.auth);
// }

// class JwtIssuer {
//   final String issuer = 'alice';

//   void create({
//     required Duration expiresIn,
//   }) {
//     final claims = JsonWebTokenClaims.fromJson({
//       'exp': expiresIn.inSeconds,
//       'iss': issuer,
//     });

//     final builder = JsonWebSignatureBuilder();

//     builder.jsonContent = claims.toJson();

//     builder.addRecipient(
//         JsonWebKey.fromJson({
//           'kty': 'oct',
//         }),
//         algorithm: 'HS256');

//     final jws = builder.build();
//   }

//   Future<void> verify(String jwtEncoded) async {
//     final jwt = JsonWebToken.unverified(jwtEncoded);

//     final keyStore = JsonWebKeyStore()
//       ..addKey(JsonWebKey.fromJson({
//         'kty': 'oct',
//       }));

//     final verified = await jwt.verify(keyStore);
//     var violations = jwt.claims.validate(issuer: Uri.parse("alice"));
//   }
// }

// class JwtConsumer {}
