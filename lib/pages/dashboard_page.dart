import 'package:FitStack/app/providers/bloc/app/app_bloc.dart';
import 'package:FitStack/app/providers/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:FitStack/features/dashboard/presentation/molecules/workout_recommendations%20_list.dart';
import 'package:FitStack/features/dashboard/presentation/molecules/statistics_dashboard.dart';
import 'package:FitStack/features/dashboard/presentation/organisms/user_statistics_snpashot_list.dart';
import 'package:FitStack/features/profile/cubit/profile_cubit.dart';
import 'package:FitStack/features/signup/ui/widgets/atoms/profile_avatar_widget.dart';
import 'package:FitStack/widgets/atoms/basic_view_header.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(viewportFraction: 0.5);
    const double bottomPadding = 17;
    const double topPadding = 25;
    const double textLabelScale = 1.2;
    final TextStyle labelTextStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
          fontWeight: FontWeight.bold,
        );

    return SafeArea(
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            BasicPageHeader(
              title: "DASHBOARD",
              trailing: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return ProfileAvatar(
                      onTap: () => context.push("/user"),
                      avatar: context.read<AppBloc>().state.user?.profile.avatar,
                      withBorder: false,
                      maxRadius: 17,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, topPadding - 5, 0, 0),
                    child: Text(
                      "Stats",
                      textScaleFactor: textLabelScale,
                      style: labelTextStyle,
                    ),
                  ),
                  const Statistics_Dashboard(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, topPadding, 0, bottomPadding),
                    child: Text(
                      "Up Next",
                      textScaleFactor: textLabelScale,
                      style: labelTextStyle,
                    ),
                  ),
                  Workout_Recommendation_List(pageController: pageController),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, topPadding, 10, bottomPadding),
                    child: Row(
                      children: [
                        Text("Progress Snapshot", textScaleFactor: textLabelScale, style: labelTextStyle),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.read<UserStatisticsBloc>().add(UserStatisticsRequested()),
                          child: BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
                            builder: (context, state) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.status == UserStatisticsStatus.loading ? "syncing" : "sync",
                                    textScaleFactor: 1.1,
                                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                          color: Theme.of(context).colorScheme.onBackground,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(width: 5),
                                  Spin(
                                    controller: (controller) =>
                                        state.status == UserStatisticsStatus.loading ? controller.repeat() : controller.stop(),
                                    infinite: true,
                                    child: Icon(
                                      FontAwesome.rotate,
                                      size: 15,
                                      color: Theme.of(context).colorScheme.onBackground,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .2, child: const UserProgressSnapshotList()),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .1)
          ],
        ),
      ),
    );
  }
}
