import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:git_viewer/data/models/dialog_models.dart';
import 'package:git_viewer/domain/services/dialog_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../injection_container.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = sl<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    Alert alert;
    if (request is AlertRequest) {
      alert = getAlertDialog(request);
    }
    if(request is ChangeGitRepoRequest){
      alert = getChangeGitRepoDialog();
    }
    if(alert!=null)
      alert.show();
  }

  Alert getChangeGitRepoDialog(){
    return Alert(
        context: context,
        title: "Add Git Project Detail",
        content: GitRepoChangeDialog(_dialogService),
        buttons: []

    );
  }

  Alert getAlertDialog(AlertRequest request){
    return Alert(
        context: context,
        title: request.title,
        desc: request.description,
        closeFunction: () =>
            _dialogService.dialogComplete(ChangeGitRepoResponse(confirmed: false)),
        buttons: [
          DialogButton(
            child: Text(request.buttonTitle),
            onPressed: () {
              _dialogService.dialogComplete(ChangeGitRepoResponse(confirmed: true));
              Navigator.of(context).pop();
            },
          )
        ]);
  }
}


class GitRepoChangeDialog extends StatefulWidget {
  DialogService dialogService;
  GitRepoChangeDialog(this.dialogService);

  @override
  _GitRepoChangeDialogState createState() => _GitRepoChangeDialogState();
}

class _GitRepoChangeDialogState extends State<GitRepoChangeDialog> {

  TextEditingController _userNameController;
  TextEditingController _projectNameController;
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _projectNameController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _projectNameController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _userNameController,
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle),
              labelText: 'User Name',
            ),
            validator: (value){
              if(value.isEmpty){
                return 'Please enter user name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _projectNameController,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Project Name',
            ),
            validator: (value){
              if(value.isEmpty){
                return 'Please enter project name';
              }
              return null;
            },
          ),
          RaisedButton(
            child: Text("Submit"),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                widget.dialogService.dialogComplete(ChangeGitRepoResponse(
                    userName: _userNameController.text,
                    projectName: _projectNameController.text,
                    confirmed: true
                ));
                Navigator.of(context).pop();
              }
            },
          )

        ],
      ),
    );
  }
}


