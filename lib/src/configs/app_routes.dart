import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../features/pages.dart';
import '../models/models.dart';
import '../services/services.dart';

class AppRoutes {
  static final GoRouter _router = GoRouter(
    initialLocation: SplashscreenPage.route,
    observers: [TalkerRouteObserver(LoggerService.talker)],
    routes: [
      GoRoute(
        name: SplashscreenPage.route,
        path: SplashscreenPage.route,
        builder: (context, state) => const SplashscreenPage(),
      ),
      GoRoute(
        name: IntroPage.route,
        path: IntroPage.route,
        builder: (context, state) => const IntroPage(),
      ),
      GoRoute(
        name: HomePage.route,
        path: HomePage.route,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: CreateUserPage.route,
        path: CreateUserPage.route,
        builder: (context, state) {
          final user = state.extra as UserModel?;
          return CreateUserPage(userModel: user,);
        },
      ),
      GoRoute(
        name: CreateUpdateUserSuccessPage.route,
        path: CreateUpdateUserSuccessPage.route,
        builder: (context, state) {
           final user = state.extra as UserModel?;
          return CreateUpdateUserSuccessPage(userModel: user,);
        } 
      ),
       GoRoute(
        name: DeleteUserSuccessPage.route,
        path: DeleteUserSuccessPage.route,
        builder: (context, state) => const DeleteUserSuccessPage(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
