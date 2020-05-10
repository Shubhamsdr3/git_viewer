import 'package:git_viewer/domain/services/authentication_service.dart';
import 'package:git_viewer/domain/services/dialog_service.dart';
import 'package:git_viewer/domain/services/navigation_service.dart';
import 'package:meta/meta.dart';

import '../../injection_container.dart';
import '../../router.dart';
import 'base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService = sl<AuthenticationService>();
//  final DialogService _dialogService = sl<DialogService>();
  final NavigationService _navigationService = sl<NavigationService>();

  Future login({@required String email, @required String password}) async {
    setBusy(true);

    var result = await _authenticationService.signUpWithEmail(
        email: email, password: password);

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeRoute);
      } else {
//        await _dialogService.showDialog(
//          title: 'Login Failure',
//          description: 'Couldn\'t login at this moment. Please try again later',
//        );
      }
    } else {
//      await _dialogService.showDialog(
//        title: 'Login Failure',
//        description: result,
//      );
    }
  }

  Future googleSignin() async {
    setBusy(true);
    var result = await _authenticationService.googleSignIn();
    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeRoute);
      }
    }
  }
}