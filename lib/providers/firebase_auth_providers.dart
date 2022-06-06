import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseAuthServiceProvider =
    Provider<FirebaseAuthService>((ref) => FirebaseAuthService());

final authStateProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthServiceProvider).authStateChange);
