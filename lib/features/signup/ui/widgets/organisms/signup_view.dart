import 'dart:developer';

import 'package:FitStack/features/signup/state/signup_cubit.dart';
import 'package:FitStack/features/signup/ui/widgets/atoms/signup_focused_button.dart';
import 'package:FitStack/features/signup/ui/widgets/molecules/social_auth_buttons.dart';
import 'package:FitStack/features/signup/ui/widgets/organisms/basic_info_form_view.dart';
import 'package:FitStack/features/signup/ui/widgets/organisms/first_last_name_form_view.dart';
import 'package:FitStack/features/signup/ui/widgets/organisms/health_stats_form_view.dart';
import 'package:FitStack/features/signup/ui/widgets/organisms/upload_picture_form_view.dart';
import 'package:FitStack/features/signup/ui/widgets/organisms/user_account_auth_form_view.dart';
import 'package:FitStack/features/signup/ui/widgets/organisms/username_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp_View extends StatelessWidget {
  const SignUp_View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> forms = [
      BasicInfoFormView(),
      UsernameFormView(),
      FirstLastNameFormView(),
      UploadPictureFormView(),
      HealthStatsFormView(),
      UserAccountAuthFormView(),
    ];

    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) {
        if (previous.errorMessage != current.errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text(
                "error: ${current.errorMessage}",
                textAlign: TextAlign.center,
              ),
            ),
          );
          return true;
        } else if (previous.index != current.index) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state.indexRange < 2) {
          log("form length == ${forms.length}");
          BlocProvider.of<SignupCubit>(context).setIndexRange(forms.length);
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              Expanded(child: forms[state.index]),
              SignUpFocusedButton(text: 'Next', index: state.index),
              SocialAuthButtons(),
            ],
          ),
        );
      },
    );
  }
}
