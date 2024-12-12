import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/app_state.dart';
import 'screens/welcome_screen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Movie of the day',
      theme: primaryTheme,
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      
    );
  }
}
