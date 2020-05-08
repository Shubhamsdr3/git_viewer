import 'package:flutter/material.dart';
import 'package:git_viewer/presentation/manager/dialog_manager.dart';
import 'package:git_viewer/presentation/pages/git_viewer.dart';

import 'injection_container.dart' as di;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, widget) => Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(
              child: widget,
            )),
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: SafeArea(child: GitViewer())),
    );
  }
}
