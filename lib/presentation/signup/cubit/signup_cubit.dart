import 'dart:developer';
import 'dart:io';

import 'package:FitStack/app/models/user/user_model.dart' as fs;
import 'package:FitStack/app/models/user/user_profile_model.dart';
import 'package:FitStack/app/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:health/health.dart';
import 'package:image_picker/image_picker.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthenticationRepository authRepository;
  SignupCubit({required this.authRepository}) : super(SignupState());

  void usernameChanged(String username) {
    List<GlobalKey<FormBuilderState>>? formKeyList = state.formKey;
    if (username.length > 3) {
      formKeyList?[state.index].currentState!.validate();
    } else {
      formKeyList?[state.index].currentState!.invalidateFirstField(errorText: 'Must be more than 3 characters');
    }
    log("form key validation: ${formKeyList?[state.index].currentState!.isValid}");
    emit(
      state.copyWith(username: username, formKey: formKeyList),
    );
  }

  void firstLastNameChanged(String firstLast) {
    List<GlobalKey<FormBuilderState>>? formKeyList = state.formKey;
    if (firstLast.length > 5 && firstLast.contains(" ")) {
      formKeyList?[state.index].currentState!.validate();
    } else {
      formKeyList?[state.index].currentState!.invalidateFirstField(errorText: 'Must be more than 5 characters and contain a space');
    }
    emit(
      state.copyWith(firstLastName: firstLast, formKey: formKeyList),
    );
  }

  void changeProfileImage(BuildContext context) async {
    try {
      UploadTask? uploadTask;

      await ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/${value?.path}');
        uploadTask = firebaseStorageRef.putFile(File(value!.path));
      }).onError(
        (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${error}")));
        },
      );

      String? url = await uploadTask?.then((p0) => p0.ref.getDownloadURL());

      emit(
        state.copyWith(profileImage: url),
      );

      state.user?.updatePhotoURL(url);
    } catch (e) {
      log("$e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text("${e}"),
      ));
    }
  }

  void healthDataChanged(List<HealthDataType>? PassedHealthDataTypeList) async {
    HealthFactory health = HealthFactory();
    List<HealthDataPoint> healthDataList = [];
    final now = DateTime.now();
    final timeSeparation = now.subtract(Duration(days: 1000));
    final types = PassedHealthDataTypeList ??
        [
          HealthDataType.STEPS,
          HealthDataType.BLOOD_GLUCOSE,
          HealthDataType.ACTIVE_ENERGY_BURNED,
          HealthDataType.BODY_FAT_PERCENTAGE,
          HealthDataType.BODY_MASS_INDEX,
          HealthDataType.HEART_RATE,
          HealthDataType.HEIGHT,
          HealthDataType.WEIGHT,
          //!sleep
          HealthDataType.SLEEP_IN_BED,
          HealthDataType.SLEEP_ASLEEP,
          HealthDataType.SLEEP_AWAKE,

          HealthDataType.WATER,
          HealthDataType.WORKOUT,
        ];
    List<HealthDataAccess> permissions = [];
    types.forEach((element) => permissions.add(HealthDataAccess.READ_WRITE));

    bool requested = await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(timeSeparation, now, types);
        healthDataList = HealthFactory.removeDuplicates(healthData);

        log("height type: ${healthDataList.where((element) => element.type == HealthDataType.HEIGHT)}");
        HealthDataPoint? healthDataWeight = healthDataList.where((element) => element.type == HealthDataType.WEIGHT).first;
        HealthDataPoint? healthDataHeight = healthDataList.where((element) => element.type == HealthDataType.HEIGHT).first;

        var height = double.tryParse(healthDataHeight.value.toString())! * 39.37007874;
        var weight = (double.tryParse(healthDataWeight.value.toString())! * 2.20462262185).roundToDouble();
        var heightFt = (height / 12).floor();
        var heightInch = (height % 12).round();

        GlobalKey<FormBuilderState> formKey = state.formKey![state.index];
        if (formKey.currentState!.fields.containsKey('heightFt')) {
          formKey.currentState?.fields['heightFt']?.didChange("$heightFt");
          formKey.currentState?.fields['heightInch']?.didChange("$heightInch");
          formKey.currentState?.fields['weight']?.didChange("$weight");
        }

        formKeyChanged(formKey);
        emit(state.copyWith(healthData: healthDataList, weight: weight, heightFt: heightFt, heightInch: heightInch));
      } catch (error) {
        log("Exception in getHealthDataFromTypes: ${error.toString()}");
      }
    } else {
      log("no permissions given");
    }
  }

  void setIndexRange(int range) {
    List<GlobalKey<FormBuilderState>> formKey = [];
    for (int i = 0; i <= range; i++) {
      formKey.add(GlobalKey<FormBuilderState>());
    }
    emit(state.copyWith(indexRange: range, formKey: formKey));
  }

  void dateOfBirthChanged(DateTime? dob) {
    emit(state.copyWith(dob: dob));
  }

  void weightChanged(double? weight) {
    emit(state.copyWith(weight: weight));
  }

  void heightFtChanged(int? heightFt) {
    emit(state.copyWith(heightFt: heightFt));
  }

  void heightInchChanged(int? heightInch) {
    emit(state.copyWith(heightInch: heightInch));
  }

  void assignedSexChanged(AssignedSex assignedSex) {
    emit(state.copyWith(assignedSex: assignedSex));
  }

  void passwordChanged(String? password) {
    emit(state.copyWith(password: password));
  }

  void emailChanged(String? email) {
    emit(state.copyWith(email: email));
  }

  void formKeyChanged(GlobalKey<FormBuilderState>? formKey) {
    List<GlobalKey<FormBuilderState>> keyList = state.formKey!;
    keyList.replaceRange(state.index, state.index, [formKey!]);

    if (keyList[state.index].currentState?.value == state.formKey?[state.index].currentState?.value) {
      log("the keys where the same. No change");
    } else
      emit(state.copyWith(formKey: keyList));
  }

  void nextPage(BuildContext context) async {
    bool isValid = state.formKey![state.index].currentState!.isValid;
    if (isValid && state.index + 1 != state.indexRange) {
      emit(state.copyWith(index: state.index + 1));
    } else if (state.indexRange == state.index + 1 && isValid) {
      emit(state.copyWith(authState: AuthState.AUTHORIZING));
      try {
        await authRepository
            .userSignUp(
          user: fs.User(
            profile: UserProfile(
              display_name: state.username,
              id: '',
              achievements: [],
              avatar: '',
              challenges: [],
              days_logged_in_a_row: 0,
              fit_credits: 0,
              social_points: 0,
              updated_at: null,
              user_statistics: null,
            ),
            date_of_birth: state.dob!,
            first_name: state.firstLastName.split(" ")[0],
            last_name: state.firstLastName.split(" ")[1],
            email_verified: false,
            email: state.email,
            phone_number: state.phoneNumber,
            password: state.password,
          ),
        )
            .onError((error, stackTrace) {
          emit(state.copyWith(errorMessage: "$error"));
          return fs.User.empty();
        });
      } catch (e) {
        emit(
          state.copyWith(
            errorMessage:
                "${state.formKey![0].currentState!.fields.entries.where((element) => !element.value.isValid).map((e) => "${e.key}: ${e.value.errorText}")}",
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          errorMessage:
              "${state.formKey![0].currentState!.fields.entries.where((element) => !element.value.isValid).map((e) => "${e.key}: ${e.value.errorText}")}",
        ),
      );
    }
  }

  void previousPage(BuildContext context) {
    if (state.index == 0) {
      Navigator.pop(context);
    } else {
      emit(state.copyWith(index: state.index - 1));
    }
  }

  void phoneNumberChanged(String? phoneNumber) {
    emit(state.copyWith(phoneNumber: phoneNumber));
  }
}
