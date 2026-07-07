import 'package:foodhome_app/features/shell/home_shell.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const home = '/';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeShell(),
    ),
  ],
);
