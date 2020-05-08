import 'package:flutter/material.dart';
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
        title: "LOGIN",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Username',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "LOGIN",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]);
  }

  Alert getAlertDialog(AlertRequest request){
    return Alert(
        context: context,
        title: request.title,
        desc: request.description,
        closeFunction: () =>
            _dialogService.dialogComplete(AlertResponse(confirmed: false)),
        buttons: [
          DialogButton(
            child: Text(request.buttonTitle),
            onPressed: () {
              _dialogService.dialogComplete(AlertResponse(confirmed: true));
              Navigator.of(context).pop();
            },
          )
        ]);
  }

}