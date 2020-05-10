import 'package:flutter/material.dart';
import 'package:git_viewer/presentation/pages/git_viewer.dart';
import 'package:git_viewer/presentation/pages/home_view.dart';
import 'package:git_viewer/presentation/pages/login_view.dart';

const String HomeRoute = "/";
const String ViewerRoute = "/viewer";
const String LoginViewRoute = "/login";
const String InitialRoute = LoginViewRoute;


class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginViewRoute:
        return MaterialPageRoute(builder: (_) => LoginView());


      case HomeRoute:
        return MaterialPageRoute(builder: (_) => HomeView());

      case ViewerRoute:
        var projectEntity=settings.arguments;
        return MaterialPageRoute(builder: (_) => GitViewer(projectEntity));

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