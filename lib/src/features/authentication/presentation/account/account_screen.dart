import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/action_text_button.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Simple account screen showing some user info and a logout button.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(accountScreenControllerProvider, (previousState,currentState){
      // if (currentState.hasError){
      //   showExceptionAlertDialog(
      //     context: context,
      //     title: 'Error'.hardcoded,
      //     exception: currentState.error,
      //   );
      // }
      currentState.showAlertDialogOnError(context);
    });

    final state = ref.watch(accountScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: state.isLoading ? const CircularProgressIndicator()  : Text('Account'.hardcoded),
        actions: [
          if (!state.isLoading)
              ActionTextButton(
                text: 'Logout'.hardcoded,
                onPressed: () async {
                  // * Get the navigator beforehand to prevent this warning:
                  // * Don't use 'BuildContext's across async gaps.
                  // * More info here: https://youtu.be/bzWaMpD1LHY
                  final goRouter = GoRouter.of(context);
                  final logout = await showAlertDialog(
                    context: context,
                    title: 'Are you sure?'.hardcoded,
                    cancelActionText: 'Cancel'.hardcoded,
                    defaultActionText: 'Logout'.hardcoded,
                  );
                  if (logout == true) {         
                    // the reason why we use `ref.read(accountScreenControllerProvider.notifier)` and not `ref.read(authRepositoryProvider).signOut()` so
                    // we can call and manage different state ( e.g data, loading, error) from any UI callbacks and run unit tests ( not widget tests) on the controller. 
                    // these unit tests don't depend on the UI's widget
                    // TODO: Sign out the user.
                    // ref.read(accountScreenControllerProvider) give us access the state managed by AccountScreenController, which is AsyncValue<void>
                    // ref.read(accountScreenControllerProvider.notifier) give us access the instance of StateNotifier, which is AccountScreenController. So, we can call methods, e.g signOut()
                    
                    //* we added refreshListenable: in goRouterProvider to refresh the router when the user signs out, so we no longer need to call pop here
                    // final isSucess = await 
                    ref.read(accountScreenControllerProvider.notifier).signOut();
                    // if (isSucess) goRouter.pop();
                  }
                },
              ),
        ],
      ),
      body: const ResponsiveCenter(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: UserDataTable(),
      ),
    );
  }
}

/// Simple user data table showing the uid and email
class UserDataTable extends ConsumerWidget {
  const UserDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme.titleSmall!;
    // TODO: get user from auth repository
    // const user = AppUser(uid: '123', email: 'test@test.com');
    final user = ref.watch(authStateChangeProvider).value;

    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            'Field'.hardcoded,
            style: style,
          ),
        ),
        DataColumn(
          label: Text(
            'Value'.hardcoded,
            style: style,
          ),
        ),
      ],
      rows: [
        _makeDataRow(
          'uid'.hardcoded,
          user?.uid ?? '',
          style,
        ),
        _makeDataRow(
          'email'.hardcoded,
          user?.email ?? '',
          style,
        ),
      ],
    );
  }

  DataRow _makeDataRow(String name, String value, TextStyle style) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            name,
            style: style,
          ),
        ),
        DataCell(
          Text(
            value,
            style: style,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
