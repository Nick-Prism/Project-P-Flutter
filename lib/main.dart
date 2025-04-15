import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/config/firebase_config.dart';
import 'core/navigation/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/event/presentation/providers/event_provider.dart';
import 'features/event/data/repositories/firebase_event_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(FirebaseAuthRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => EventProvider(FirebaseEventRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Project P',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: '/splash',
      ),
    );
  }
}
