import 'package:final_project/screens/select_movie_screen.dart';
import 'package:final_project/utils/app_state.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/styled_text.dart'; 
import '../theme.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle('Enter Code'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const StyledHeading('Join Session'),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  style: StyledFormInput.style,
                  decoration: InputDecoration(
                    labelText: 'Enter Code',
                    labelStyle: StyledFormPlaceholder.style,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.dislikeColor),
                    ),
                    filled: true,
                    fillColor: AppColors.secondaryColor,
                    counterStyle: StyledFormPlaceholder.style,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the code you got from your friend';
                    }
                    if (value.length != 4) {
                      return 'Code must be 4 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _joinSession,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.titleColor,
                    disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.titleColor,
                            ),
                          ),
                        )
                      : const StyledText('Join Session'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _joinSession() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final deviceId = Provider.of<AppState>(context, listen: false).deviceId;
    final appState = Provider.of<AppState>(context, listen: false);
    
    try {
      final response = await HttpHelper.joinSession(
        deviceId,
        _codeController.text,
      );
      
      if (!mounted) return;

      if (response['data']['session_id'] != null) {
        await appState.setSessionId(response['data']['session_id']);
        
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MovieSelectionScreen()),
        );
      }
    } catch (e) {
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
                child: StyledText('Error: ${e.toString()}'),
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }



}
