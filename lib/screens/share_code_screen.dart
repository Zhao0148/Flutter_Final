import 'package:final_project/screens/select_movie_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/styled_text.dart';  
import '../theme.dart';
import '../utils/app_state.dart';
import '../utils/http_helper.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  String code = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle('Share Code'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const StyledText('Creating session...'),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const StyledHeading('Share this code with your friend'),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: StyledHeading(code),
                    ),
                    const SizedBox(height: 48),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.dislikeColor.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.dislikeColor,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          const StyledText(
                            'Please make sure your friend has joined the session\nbefore starting movie selection.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MovieSelectionScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.titleColor,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      child: const StyledText('Start Movie Selection'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _startSession() async {
    try {
      String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;
      if (kDebugMode) {
        print('Device id from Share Code Screen: $deviceId');
      }

      final response = await HttpHelper.startSession(deviceId);

      if (!mounted) return;

      Provider.of<AppState>(context, listen: false).setSessionId(response['data']['session_id']);

      setState(() {
        code = response['data']['code'];
        isLoading = false;
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error starting session: $error');
      }
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.dislikeColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StyledText('Error: ${error.toString()}'),
              ),
            ],
          ),
          backgroundColor: AppColors.secondaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}
