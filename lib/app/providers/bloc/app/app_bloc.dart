import 'dart:async';
import 'dart:developer';
import 'package:FitStack/app/helpers/fitstack_error_toast.dart';
import 'package:FitStack/app/models/user/user_model.dart';
import 'package:FitStack/app/repository/auth_repository.dart';
import 'package:FitStack/app/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  late StreamSubscription<AuthStream> authenticationStatusSubscription;

  AppBloc({required this.authenticationRepository, required this.userRepository}) : super(const AppState.unknown()) {
    on<AuthenticationStatusChanged>(onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(onAuthenticationLogoutRequested);
    on<AuthenticationPersistRequested>(onAuthenticationPersistRequested);
    authenticationStatusSubscription = authenticationRepository.status.listen((status) => add(AuthenticationStatusChanged(status)));
  }

  void onLogoutRequested(AuthenticationLogoutRequested event, Emitter<AppState> emit) {
    authenticationRepository.logOut();
  }

  @override
  Future<void> close() {
    authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> onAuthenticationStatusChanged(AuthenticationStatusChanged event, Emitter<AppState> emit) async {
    switch (event.status.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AppState.unauthenticated());

      case AuthenticationStatus.authenticated:
        final user = event.status.user;
        return emit(
          user != User.empty() ? AppState.authenticated(user) : const AppState.unauthenticated(),
        );

      case AuthenticationStatus.authenticating:
        return emit(const AppState.authenticating());

      case AuthenticationStatus.error:
        FitStackToast.showErrorToast("error logging in ${event.status.message}");
        return emit(const AppState.unauthenticated());

      case AuthenticationStatus.unknown:
        return emit(const AppState.unknown());
    }
  }

  void onAuthenticationLogoutRequested(AuthenticationLogoutRequested event, Emitter<AppState> emit) {
    authenticationRepository.logOut();
  }

  Future<void> onAuthenticationPersistRequested(AuthenticationPersistRequested event, Emitter<AppState> emit) async {
    emit(state.copyWith(status: AuthenticationStatus.authenticating));
    try {
      await authenticationRepository.persistLogin();
      log("persisted login");
    } catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
    }
    emit(state.copyWith(status: AuthenticationStatus.authenticated));
  }
}
