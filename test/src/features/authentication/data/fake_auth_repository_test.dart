import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  FakeAuthRepository makeAuthRepository () => FakeAuthRepository(addDelay:false);
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  final testUser = AppUser(
    uid: testEmail.split('').reversed.join(), 
    email: testEmail 
  );

  group('FakeAuthRepository', () {
    test('current user is null', () {
      final authRepository = makeAuthRepository();

      // register the dispose method to be called after test completes, regardless test passes or fails
      addTearDown(authRepository.dispose);
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });
  });

    test('current user is not null after sign in', () async {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('current user is not null after register', () async {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      await authRepository.createUserWithEmailAndPassword(testEmail, testPassword);
      
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('current user is null after sign out', () async {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);

      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      expect(authRepository.authStateChanges(), emits(testUser));
      expect(authRepository.currentUser, testUser);


      await authRepository.signOut();   
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('current user is current user then null after sign out', () async {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      
      expect(
        authRepository.authStateChanges(), // value from signInWithEmailAndPassword()
        emitsInOrder([testUser, null]), // upcoming value from signOut()
      );
      
      await authRepository.signOut();
      expect(authRepository.currentUser, null);
    });

    test('sign in after dispose throws error', () async {
      // initializes FakeAuthRepository instance using makeAuthRepository()
      final authRepository = makeAuthRepository();
      // calls the dispose method immediately at this point in the test
      authRepository.dispose();

      expect(
        () => authRepository.signInWithEmailAndPassword(testEmail, testPassword),
        throwsStateError);

      expect(authRepository.currentUser, null);
    });

}