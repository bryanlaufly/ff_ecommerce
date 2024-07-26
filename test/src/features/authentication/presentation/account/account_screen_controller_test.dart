import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {

  late MockAuthRepository mockAuthRepository;
  late AccountScreenController controller;

  setUpAll((){
    mockAuthRepository = MockAuthRepository();
    controller = AccountScreenController(
      authRepository  : mockAuthRepository
    );
  });

  group('AccountScreenController', () {
    // test('initial state is AsyncValue.data(null)', () {
    //   final AuthRepository repository = FakeAuthRepository();
    //   final controller = AccountScreenController(authRepository: repository);
    //   expect(controller.state, const AsyncValue<void>.data(null));
    // });

    test('initial state is AsyncValue.data / AsyncData', () {

      // to verify the signOut is never called
      verifyNever(() => mockAuthRepository.signOut());
      // to checks the type
      expect(controller.state, isA<AsyncData<void>>());
      // to check the state ( includes the type (AsyncData) and value(null)   
      expect(controller.state, const AsyncValue<void>.data(null));
    });

    test('sign out success', () async {

      // we define how the mock should behave when signOut is called
      when(() => mockAuthRepository.signOut()).thenAnswer((_) => Future.value());
      
      await controller.signOut();
      
      verify(() => mockAuthRepository.signOut()).called(1);
      expect(controller.state, const AsyncValue<void>.data(null));

    });

    test('sign out failure', () async {
 
      final exception = Exception('Sign out failed');
      when(() => mockAuthRepository.signOut()).thenThrow(exception);
      final controller = AccountScreenController(authRepository: mockAuthRepository);
      
      await controller.signOut();
      
      verify(() => mockAuthRepository.signOut()).called(1);

      // this will fail because we can match the exception but not the stack trace
      // expect(controller.state, AsyncError<void>(exception, StackTrace.current));

      expect(controller.state, isA<AsyncError<void>>());
      expect(controller.state.error, exception);
    });

    test('sign out success, check controller.stream', () async {

      // setup
      when(() => mockAuthRepository.signOut()).thenAnswer((_) => Future.value());
      
      // controller.stream or expectLater is at the top because AsyncLoading emits first, then AsyncData  
      expectLater(
        controller.stream,
        emitsInOrder([
          isA<AsyncLoading<void>>(),
          isA<AsyncData<void>>(),
        ]),
      );
      
      // run
      await controller.signOut();
      
      // verify
      verify(() => mockAuthRepository.signOut()).called(1);
      expect(controller.state, const AsyncValue<void>.data(null));

    }, timeout: const Timeout(Duration(seconds : 1))
    ); // fail fast

    test('sign out failure, check controller.stream', () async {

      final exception = Exception('Sign out failed');
      when(() => mockAuthRepository.signOut()).thenThrow(exception);
      
      expectLater(
        controller.stream,
        emitsInOrder([
          isA<AsyncLoading<void>>(),
          isA<AsyncError<void>>(),
        ]),
      );      
      await controller.signOut();
      
      verify(() => mockAuthRepository.signOut()).called(1);
      expect(controller.state, isA<AsyncError<void>>());
      expect(controller.state.error, exception);
    }, timeout: const Timeout(Duration(seconds: 1)));

    test('sign out failure, check predicate', () async {

      final exception = Exception('Sign out failed');
      when(() => mockAuthRepository.signOut()).thenThrow(exception);
      
      await controller.signOut();
      
      verify(() => mockAuthRepository.signOut()).called(1);
      expect(
        controller.state,
        predicate<AsyncValue<void>>((value) =>
            value.hasError && value.error == exception),
      );
    }, timeout: const Timeout(Duration(seconds: 1)));

    test('sign out failed, use predicate and controller stream, also follow set up, expect later, run, verify', () async {
      // set up
      final exception = Exception('Sign out failed');
      when(() => mockAuthRepository.signOut()).thenThrow(exception);

      // expectlater
      expectLater(
        controller.stream,
        emitsInOrder([
          isA<AsyncLoading<void>>(),
          predicate<AsyncValue<void>>((value) =>
              value.hasError && value.error == exception),
        ]),
      );

      // run
      await controller.signOut();
      
      // verify
      verify(() => mockAuthRepository.signOut()).called(1);
     
    }, timeout: const Timeout(Duration(seconds: 1)));
  });
}

  
