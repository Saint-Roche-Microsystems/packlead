import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/config/service_mode.dart';
import 'package:packlead/core/constants/user_status.dart';
import 'package:packlead/core/themes/core/color_schema.dart';
import 'package:packlead/core/widgets/form_fields/email_field.dart';
import 'package:packlead/core/widgets/form_fields/password_field.dart';
import 'package:packlead/core/widgets/snackbars.dart';
import 'package:packlead/features/auth/presentation/providers/auth_provider.dart';
import 'package:packlead/features/auth/presentation/providers/auth_state.dart';
import 'package:packlead/features/auth/presentation/widgets/quick_login_buttons.dart';
import 'package:packlead/mocks/dispatcher_mock_selector.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(authStateProvider.notifier).login(_emailCtrl.text, _pwdCtrl.text);
  }

  void _fillAdminCredentials() {
    setState(() {
      _emailCtrl.text = 'admin@packlead.com';
      _pwdCtrl.text = 'admin123';
    });
  }

  void _fillDispatcherCredentials() {
    final credentials = getRandomMockDispatcher();
    setState(() {
      _emailCtrl.text = credentials?.email ?? '';
      _pwdCtrl.text = credentials?.password ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(ErrorSnackBar(message: next.errorMessage!));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              Center(
                child: Image.asset(
                  'assets/packlead_logo.png',
                  width: 250,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    EmailField(
                      controller: _emailCtrl,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 20),

                    PasswordField(
                      controller: _pwdCtrl,
                      obscurePassword: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      onIconPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authState.status == AuthStatus.loading
                            ? null
                            : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: authState.status == AuthStatus.loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: SaintColors.surface,
                                ),
                              ),
                      ),
                    ),

                    // Quick buttons ONLY when app is set to use MOCK data
                    if (AppServiceMode.isMock)
                      QuickLoginButtons(
                        onAdminLogin: _fillAdminCredentials,
                        onDispatcherLogin: _fillDispatcherCredentials,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
