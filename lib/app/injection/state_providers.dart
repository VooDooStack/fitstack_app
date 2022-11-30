import 'package:FitStack/app/providers/bloc/active_workout/active_workout_bloc.dart';
import 'package:FitStack/app/providers/bloc/app/app_bloc.dart';
import 'package:FitStack/app/providers/bloc/bloc/nutrition_bloc.dart';
import 'package:FitStack/app/providers/bloc/exercise/exercise_bloc.dart';
import 'package:FitStack/app/providers/bloc/workout/workout_bloc.dart';
import 'package:FitStack/app/providers/cubit/main_view/main_view_cubit.dart';
import 'package:FitStack/app/providers/cubit/user_statistic/user_statistic_cubit.dart';
import 'package:FitStack/app/repository/active_workout_repository.dart';
import 'package:FitStack/app/repository/auth_repository.dart';
import 'package:FitStack/app/repository/exercise_repository.dart';
import 'package:FitStack/app/repository/open_food_facts_repository.dart';
import 'package:FitStack/app/repository/program_repository.dart';
import 'package:FitStack/app/repository/relationship_repository.dart';
import 'package:FitStack/app/repository/user_health_repository.dart';
import 'package:FitStack/app/repository/user_repository.dart';
import 'package:FitStack/app/repository/workout_repository.dart';
import 'package:FitStack/features/exercise/cubit/exercise_screen/exercise_screen_cubit.dart';
import 'package:FitStack/features/exercise/cubit/program_cubit.dart';
import 'package:FitStack/features/login/cubit/login_cubit.dart';
import 'package:FitStack/features/profile/cubit/profile_cubit.dart';
import 'package:FitStack/features/relationship/cubit/friendship/friendship_cubit.dart';
import 'package:FitStack/features/settings/cubit/settings_cubit.dart';
import 'package:FitStack/features/signup/state/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StateProviders extends StatelessWidget {
  final Widget child;
  const StateProviders({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //! blocs/repository registration
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthenticationRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
        RepositoryProvider(create: (context) => RelationshipRepository()),
        RepositoryProvider(create: (context) => ProgramRepository()),
        RepositoryProvider(create: (context) => WorkoutRepository()),
        RepositoryProvider(create: (context) => ActiveWorkoutRepository()),
        RepositoryProvider(create: (context) => ExerciseRepository()),
        RepositoryProvider(create: (context) => UserHealthRepository()),
        RepositoryProvider(create: (context) => OpenFoodFactsRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (BuildContext context) => AppBloc(
              authenticationRepository: context.read<AuthenticationRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider<LoginCubit>(
            create: (BuildContext context) => LoginCubit(
              authenticationRepository: context.read<AuthenticationRepository>()..persistLogin(),
            ),
          ),
          BlocProvider<SignupCubit>(
            create: (BuildContext context) => SignupCubit(
              authRepository: context.read<AuthenticationRepository>(),
            ),
          ),
          BlocProvider<MainViewCubit>(
            create: (BuildContext context) => MainViewCubit(),
          ),
          BlocProvider<ProfileCubit>(
            create: (BuildContext context) => ProfileCubit(
              user: context.read<AppBloc>().state.user,
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider<FriendshipCubit>(
            create: (BuildContext context) => FriendshipCubit(relationshipRepository: context.read<RelationshipRepository>()),
          ),
          BlocProvider<SettingsCubit>(
            create: (BuildContext context) => SettingsCubit(),
          ),
          BlocProvider<ProgramCubit>(
            create: (BuildContext context) => ProgramCubit(programRepository: context.read<ProgramRepository>()),
          ),
          BlocProvider<UserStatisticCubit>(
            create: (BuildContext context) =>
                UserStatisticCubit(userRepository: context.read<UserRepository>(), userHealthRepository: context.read<UserHealthRepository>())
                  ..getUserStatistic(),
          ),
          BlocProvider<WorkoutBloc>(
            create: (BuildContext context) => WorkoutBloc(
              workoutRepository: context.read<WorkoutRepository>(),
            )..add(WorkoutStreamSubscriptionRequested()),
          ),
          BlocProvider<ActiveWorkoutBloc>(
            create: (BuildContext context) =>
                ActiveWorkoutBloc(activeWorkoutRepository: context.read<ActiveWorkoutRepository>())..add(LoadExerciseList()),
          ),
          BlocProvider<ExerciseScreenCubit>(
            create: (BuildContext context) => ExerciseScreenCubit(),
          ),
          BlocProvider<ExerciseBloc>(
            create: (BuildContext context) => ExerciseBloc(exerciseRepository: context.read<ExerciseRepository>())..add(LoadExercises()),
          ),
          BlocProvider<NutritionBloc>(
              create: (BuildContext context) => NutritionBloc(openFoodFactsRepository: context.read<OpenFoodFactsRepository>())),
        ],
        child: child,
      ),
    );
  }
}
