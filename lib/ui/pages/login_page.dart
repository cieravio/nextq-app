import 'package:nextq_app/providers/shared_preference_provider.dart';
import 'package:nextq_app/ui/static/firebase_auth_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nextq_app/providers/firebase_auth_provider.dart';
import 'package:nextq_app/ui/static/navigation_route.dart';
import 'package:nextq_app/widget/textfield_obsecure_widget.dart';

const Color _primaryBackgroundColor = Color(0xFFF0F4F8);
const Color _accentColor = Color(0xFF10B981);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  InputDecoration _buildInputDecoration({
    required String labelText,
    required IconData icon,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: _accentColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon, color: Colors.black54),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'nextq-app',
                child: Text(
                  'NextQ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: _accentColor,
                        letterSpacing: 1.5,
                      ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Sign In to continue',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black54,
                    ),
              ),
              const SizedBox(height: 48.0),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration(
                  labelText: 'Email Address',
                  icon: Icons.email_rounded,
                  hintText: 'e.g., yourname@example.com',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFieldObscure(
                controller: _passwordController,
                hintText: 'Enter your password',
                decoration: _buildInputDecoration(
                  labelText: 'Password',
                  icon: Icons.lock_rounded,
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 32.0),
              Consumer<FirebaseAuthProvider>(
                builder: (context, value, child) {
                  return SizedBox(
                    height: 56,
                    child: switch (value.authStatus) {
                      FirebaseAuthStatus.authenticating => const Center(
                          child: CircularProgressIndicator(color: _accentColor),
                        ),
                      _ => FilledButton(
                          onPressed: () => _tapToLogin(),
                          style: FilledButton.styleFrom(
                            backgroundColor: _accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          child: const Text('Login'),
                        ),
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => _goToRegister(),
                child: Text.rich(
                  TextSpan(
                    text: 'Don\'t have an account yet? ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black54,
                        ),
                    children: [
                      TextSpan(
                        text: 'Register here',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _accentColor,
                            ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    final navigator = Navigator.of(context);
    final isLogin = context.read<SharedPreferenceProvider>().isLogin;

    Future.microtask(() async {
      if (isLogin) {
        await firebaseAuthProvider.updateProfile();
        navigator.pushReplacementNamed(
          NavigationRoute.home.name,
        );
      }
    });
  }

  void _tapToLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      final sharedPreferenceProvider = context.read<SharedPreferenceProvider>();
      final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      await firebaseAuthProvider.signInUser(email, password);
      switch (firebaseAuthProvider.authStatus) {
        case FirebaseAuthStatus.authenticated:
          await sharedPreferenceProvider.login();
          navigator.pushReplacementNamed(
            NavigationRoute.home.name,
          );
        case _:
          scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(firebaseAuthProvider.message ?? ""),
          ));
      }
    } else {
      const message = "Fill the email and password correctly";

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text(message),
      ));
    }
  }

  void _goToRegister() async {
    Navigator.pushNamed(
      context,
      NavigationRoute.register.name,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
