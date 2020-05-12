
import 'package:flutter/material.dart';
import 'package:git_viewer/presentation/dialog_manager/home_page_dialog_manager.dart';

class AddGitRepoDialog extends StatefulWidget {
  final HomePageDialogService dialogService;
  AddGitRepoDialog(this.dialogService);

  @override
  _AddGitRepoDialogState createState() => _AddGitRepoDialogState();
}

class _AddGitRepoDialogState extends State<AddGitRepoDialog> {

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
                widget.dialogService.dialogComplete(GitRepoInfoResponse(
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