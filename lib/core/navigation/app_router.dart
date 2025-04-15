import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/screens/profile_setup_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/event/presentation/screens/event_list_screen.dart';
import '../../features/event/presentation/screens/event_creation_screen.dart';
import '../../features/event/presentation/screens/event_detail_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/event/domain/models/event_model.dart';
import '../../features/auth/domain/models/user_model.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return _buildRoute(settings, const SplashScreen());
      case '/login':
        return _buildRoute(settings, const LoginScreen());
      case '/events':
        return _buildRoute(settings, const EventListScreen());
      case '/events/create':
        return _buildRoute(settings, const EventCreationScreen());
      case '/events/details':
        final event = settings.arguments as Event;
        return _buildRoute(settings, EventDetailsScreen(event: event));
      case '/profile/setup':
        final user = settings.arguments as UserModel;
        return _buildRoute(
          settings,
          ProfileSetupScreen(user: user),
        );
      default:
        return _buildRoute(
          settings,
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static Route<dynamic> _buildRoute(RouteSettings settings, Widget builder) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}
