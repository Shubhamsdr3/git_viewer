import 'package:flutter/material.dart';
import 'package:git_viewer/presentation/pages/home_page.dart';
import 'package:git_viewer/presentation/pages/project_viewer_page.dart';

const String HomeRoute = "/";
const String ViewerRoute = "/viewer";
const String initialRoute = HomeRoute;

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());

      case ViewerRoute:
        var projectEntity=settings.arguments;
        return MaterialPageRoute(builder: (_) => ProjectViewerPage(projectEntity));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ));
    }
  }
}