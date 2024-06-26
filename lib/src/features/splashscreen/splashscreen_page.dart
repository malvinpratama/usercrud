import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';
import '../pages.dart';
import 'bloc/splashscreen_bloc.dart';

class SplashscreenPage extends StatelessWidget {
  static const String route = '/';
  const SplashscreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<SettingsRepository>(
      create: (context) => SettingsRepository(DatabaseService.database),
      child: BlocProvider<SplashscreenBloc>(
        create: (context) =>
            SplashscreenBloc(context.read<SettingsRepository>()),
        child: BlocListener<SplashscreenBloc, SplashscreenState>(
          listener: (context, state) {
            if (state.viewStatus == ViewStatusModel.success) {
              context.pushReplacement(IntroPage.route);
            } else if (state.viewStatus == ViewStatusModel.failure) {
              context.pushReplacement(HomePage.route);
            }
          },
          child: Scaffold(
            body: Center(
              child: Padding(
                padding: REdgeInsets.symmetric(horizontal: 68),
                child: Image.asset(ImageAssets.kLogo),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
