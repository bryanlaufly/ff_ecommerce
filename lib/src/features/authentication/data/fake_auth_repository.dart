import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChange();
  AppUser? get currentUser;
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}


class FakeAuthRepository implements AuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);

  @override
  Stream<AppUser?> authStateChange() => _authState.stream;

  @override
  AppUser? get currentUser => _authState.value;

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    // for testing purpose
    // throw Exception('error create new account');
    if (currentUser == null)  _createNewUser(email);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    // for testing purpose
    // throw Exception('error signing in');
    if (currentUser == null)  _createNewUser(email);
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 2));
    // for testing purpose
    // throw Exception('error signing out');
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email) {
    // this is incorrect as we need to take in password as input
    _authState.value = AppUser( 
      uid: email.split('').reversed.join(), 
      email: email 
    );
  }

}


// final fakeAuthRepositoryProvider = Provider<FakeAuthRepository>((ref) => FakeAuthRepository()); this doesn't work
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // flutter run --dart-defined=useFakeRepos = true / false
  // final isFake = String.fromEnvironment('useFakeRepos') == 'true' ;
  // return isFake ? FakeAuthRepository() : FirebaseAuthRepository();
  return  FakeAuthRepository();
});

final authStateChangeProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChange();
});

