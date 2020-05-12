import 'dart:async';

import 'package:flutter/material.dart';
import 'package:git_viewer/core/models/dialog_models.dart';
import 'package:git_viewer/presentation/widgets/add_git_repo_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../injection_container.dart';


// Response Model
class GitRepoInfoResponse extends DialogResponse{
  final String userName;
  final String projectName;
  final bool confirmed;

  GitRepoInfoResponse({
    this.userName,
    this.projectName,
    this.confirmed,
  });
}

class HomePageDialogService {
  Function(DialogRequest) _showDialogListener;
  Completer<DialogResponse> _dialogCompleter;

  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  Future<GitRepoInfoResponse> showGitRepoChangeDialog() {
    _dialogCompleter = Completer<GitRepoInfoResponse>();
    _showDialogListener(DialogRequest());
    return _dialogCompleter.future;
  }


  void dialogComplete(DialogResponse response) {
    _dialogCompleter.complete(response);
    _dialogCompleter = null;
  }
}

class HomePageDialogManager extends StatefulWidget {
  final Widget child;
  HomePageDialogManager({Key key, this.child}) : super(key: key);

  _HomePageDialogManagerState createState() => _HomePageDialogManagerState();
}

class _HomePageDialogManagerState extends State<HomePageDialogManager> {
  HomePageDialogService _dialogService = sl<HomePageDialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest _) {
      getChangeGitRepoDialog().show();
  }

  Alert getChangeGitRepoDialog(){
    return Alert(
        context: context,
        title: "Add Git Project Detail",
        content: AddGitRepoDialog(_dialogService),
        buttons: []

    );
  }
}

