import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>>{
  AccountScreenController({required this.authRepository}): super(const AsyncValue<void>.data(null)); 

  final AuthRepository authRepository;

// Future<bool> is useful to update UI differently based on sucessful / failed sign out
  // Future<bool> signOut() async {
    // try {
    //   state = const AsyncValue<void>.loading();
    //   await authRepository.signOut();
    //   state = const AsyncValue<void>.data(null);
    //   return true;
    // } catch (e , st) {
    //   state = AsyncValue<void>.error(e, st);
    //   return false;
    // }
    // state = const AsyncValue<void>.loading();
    // state = await AsyncValue.guard(() => authRepository.signOut());
    // return state.hasError == false;
  // }

  Future<void> signOut() async {
    state = const AsyncValue<void>.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepository);
});