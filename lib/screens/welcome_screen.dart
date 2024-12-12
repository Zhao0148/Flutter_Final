import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/styled_text.dart';
import '../utils/app_state.dart';
import 'enter_code_screen.dart';
import 'share_code_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle('Movie Night'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Consumer<AppState>(
            builder: (context, appState, child) {
              if (appState.deviceId == null) {
                return const CircularProgressIndicator();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const StyledHeading('Movie Night'), 
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShareCodeScreen(),
                        ),
                      );
                    },
                    child: const StyledText('Start New Session'), 
                  ),
                  const SizedBox(height: 32),
                  const StyledText('Choose an option to begin'), 
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EnterCodeScreen(),
                        ),
                      );
                    },
                    child: const StyledText('Join Session'), 
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
