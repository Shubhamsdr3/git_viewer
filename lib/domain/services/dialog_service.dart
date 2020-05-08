import 'dart:async';

import 'package:git_viewer/data/models/dialog_models.dart';


class DialogService {
  Function(DialogRequest) _showDialogListener;
  Completer<DialogResponse> _dialogCompleter;

  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  Future<AlertResponse> showDialog(
      {String title, String description, String buttonTitle = 'OK'}) {
    _dialogCompleter = Completer<AlertResponse>();
    _showDialogListener(AlertRequest(
      title: title,
      description: description,
      buttonTitle: buttonTitle,
    ));
    return _dialogCompleter.future;
  }

  Future<AlertResponse> showGitRepoChangeDialog() {
    _dialogCompleter = Completer<AlertResponse>();
    _showDialogListener(ChangeGitRepoRequest());
    return _dialogCompleter.future;
  }


  void dialogComplete(DialogResponse response) {
    _dialogCompleter.complete(response);
    _dialogCompleter = null;
  }
}