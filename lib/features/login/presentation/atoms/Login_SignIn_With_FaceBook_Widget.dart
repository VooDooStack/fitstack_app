import 'package:FitStack/widgets/atoms/socialAuthButton_widget.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class Login_SignIn_With_FaceBook_Widget extends StatelessWidget {
  const Login_SignIn_With_FaceBook_Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SocialAuthButton_Widget(
      color: const Color.fromRGBO(45, 113, 197, 1),
      child: Icon(
        FontAwesome.facebook_f,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
