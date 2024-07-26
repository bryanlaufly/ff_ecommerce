import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {

  const email = 'test@example.com';
  const password = 'password123';

  group(' sign in, register and update form', () {
    test('''Given formType is signIn,
      When signInWithEmailAndPassword succeeds, 
      Then return true And state is AsyncData
      ''', () async {
      // Arrange
      final MockAuthRepository mockAuthRepository = MockAuthRepository();
      final EmailPasswordSignInController controller = EmailPasswordSignInController(
        formType : EmailPasswordSignInFormType.signIn,
        authRepository: mockAuthRepository,
      );
        
      when(() => mockAuthRepository.signInWithEmailAndPassword(email, password))
          .thenAnswer((_) => Future.value());

      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncLoading(),
          ),
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncData(null),
          ),
        ]),
      );
      // Act
      final result = await controller.submit(email, password);

      // Assert
      expect(result, true);
      verify(() => mockAuthRepository.signInWithEmailAndPassword(email, password)).called(1);
    });

    test('''Given formType is signIn,
      When signInWithEmailAndPassword fails, 
      Then return false And state is AsyncError
      ''', () async {
      // Arrange
      final MockAuthRepository mockAuthRepository = MockAuthRepository();
      final EmailPasswordSignInController controller = EmailPasswordSignInController(
        formType: EmailPasswordSignInFormType.signIn,
        authRepository: mockAuthRepository,
      );
      
      final exception = Exception('Sign in failed');
      when(() => mockAuthRepository.signInWithEmailAndPassword(email, password))
          .thenThrow(exception);

      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncLoading(),
          ),
          predicate<EmailPasswordSignInState>((state) => 
            state.formType == EmailPasswordSignInFormType.signIn &&
            state.value is AsyncError &&
            (state.value as AsyncError).error == exception
          ),
        ]),
      );

      // Act
      final result = await controller.submit(email, password);

      // Assert
      expect(result, false);
      verify(() => mockAuthRepository.signInWithEmailAndPassword(email, password)).called(1);
    });

    test('''Given formType is register,
      When createUserWithEmailAndPassword succeeds, 
      Then return true And state is AsyncData
      ''', () async {
      // Arrange
      final MockAuthRepository mockAuthRepository = MockAuthRepository();
      final EmailPasswordSignInController controller = EmailPasswordSignInController(
        formType: EmailPasswordSignInFormType.register,
        authRepository: mockAuthRepository,
      );
      
      when(() => mockAuthRepository.createUserWithEmailAndPassword(email, password))
          .thenAnswer((_) => Future.value());

      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncLoading(),
          ),
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncData(null),
          ),
        ]),
      );

      // Act
      final result = await controller.submit(email, password);

      // Assert
      expect(result, true);
      verify(() => mockAuthRepository.createUserWithEmailAndPassword(email, password)).called(1);
    });

    test('''Given formType is register,
      When createUserWithEmailAndPassword fails, 
      Then return false And state is AsyncError
      ''', () async {
      // Arrange
      final MockAuthRepository mockAuthRepository = MockAuthRepository();
      final EmailPasswordSignInController controller = EmailPasswordSignInController(
        formType: EmailPasswordSignInFormType.register,
        authRepository: mockAuthRepository,
      );
      
      final exception = Exception('Registration failed');
      when(() => mockAuthRepository.createUserWithEmailAndPassword(email, password))
          .thenThrow(exception);

      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncLoading(),
          ),
          predicate<EmailPasswordSignInState>((state) =>
            state.formType == EmailPasswordSignInFormType.register &&
            state.value is AsyncError &&
            (state.value as AsyncError).error == exception
          ),
        ]),
      );

      // Act
      final result = await controller.submit(email, password);

      // Assert
      expect(result, false);
      verify(() => mockAuthRepository.createUserWithEmailAndPassword(email, password)).called(1);
    });

    test('''
    Given formType is signIn
    When called with register
    Then state.formType is register

    verify switching sign-in/register form type successfully
    ''', () {
      // Arrange
      final MockAuthRepository mockAuthRepository = MockAuthRepository();
      final EmailPasswordSignInController controller = EmailPasswordSignInController(
        formType: EmailPasswordSignInFormType.signIn,
        authRepository: mockAuthRepository,
      );

      // Act
      controller.updateFormType(EmailPasswordSignInFormType.register);

      // Assert
      expect(
        controller.state.formType,
        EmailPasswordSignInFormType.register,
      );
    });


  });
}