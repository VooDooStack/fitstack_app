import 'package:FitStack/features/signup/state/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AssignedSexButton extends StatelessWidget {
  final AutovalidateMode? autovalidateMode;

  const AssignedSexButton({Key? key, this.autovalidateMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.assignedSex != current.assignedSex,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assigned Sex',
              style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              child: FormBuilderDropdown(
                autovalidateMode: autovalidateMode ?? AutovalidateMode.always,
                name: 'assignedSex',
                onChanged: (AssignedSex? newValue) => BlocProvider.of<SignupCubit>(context).assignedSexChanged(newValue ?? AssignedSex.Unknown),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "required"),
                ]),
                iconEnabledColor: Colors.transparent,
                icon: const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    FontAwesome.angle_down,
                    size: 15,
                  ),
                ),
                style: Theme.of(context).textTheme.subtitle2,
                decoration: InputDecoration(
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      FontAwesome.angle_down,
                      size: 15,
                    ),
                  ),
                  hintText: "choose an option",
                  hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(.6)),
                  suffixIconConstraints: const BoxConstraints(maxHeight: 30, maxWidth: 40),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                items: [
                  DropdownMenuItem(
                    value: AssignedSex.Male,
                    child: Text(
                      'Male',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  DropdownMenuItem(
                    value: AssignedSex.Female,
                    child: Text(
                      'Female',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
// DropdownButton2(
                //   value: state.assignedSex == AssignedSex.Unknown ? null : state.assignedSex,
                //   buttonPadding: EdgeInsets.all(10),
                //   itemHeight: 40,
                //   isDense: false,
                //   isExpanded: true,
                //   buttonDecoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     color: Theme.of(context).colorScheme.surface,
                //   ),
                //   iconSize: 15,
                //   hint: Text(
                //     'Choose from list',
                //     style: Theme.of(context).textTheme.subtitle2,
                //   ),
                //   icon: Icon(FontAwesome.angleDown),
                //   items: [
                //     DropdownMenuItem(
                //       enabled: true,
                //       child: Text(
                //         'Male',
                //         style: Theme.of(context).textTheme.subtitle2,
                //       ),
                //       value: AssignedSex.Male,
                //     ),
                //     DropdownMenuItem(
                //       enabled: true,
                //       child: Text(
                //         'Female',
                //         style: Theme.of(context).textTheme.subtitle2,
                //       ),
                //       value: AssignedSex.Female,
                //     ),
                //   ],
                //   onChanged: (dynamic value) =>
                //       BlocProvider.of<SignupCubit>(context).assignedSexChanged(value),
                // ),