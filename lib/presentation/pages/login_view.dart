import 'package:flutter/material.dart';
import 'package:git_viewer/core/ui/ui_helpers.dart';
import 'package:git_viewer/presentation/viewmodels/auth_view_model.dart';
import 'package:git_viewer/presentation/widgets/busy_button.dart';
import 'package:git_viewer/presentation/widgets/input_field.dart';
import 'package:git_viewer/presentation/widgets/text_link.dart';

import 'base_view.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      onModelReady: (model) => {},
      builder: (context, model, child) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    child: Image.asset('assets/images/title.png'),
                  ),
                  InputField(
                    placeholder: 'Email',
                    controller: emailController,
                  ),
                  verticalSpaceSmall,
                  InputField(
                    placeholder: 'Password',
                    password: true,
                    controller: passwordController,
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BusyButton(
                        title: 'Login',
                        busy: model.busy,
                        onPressed: () {
                          model.googleSignin();
//                          model.login(
//                            email: emailController.text,
//                            password: passwordController.text,
//                          );
                        },
                      )
                    ],
                  ),
                  verticalSpaceMedium,
                  TextLink(
                    'Create an Account if you\'re new.',
                    onPressed: () {
                      // TODO: Handle navigation
                    },
                  )
                ],
              ),
            ));
      }
    );

  }
}