import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _emailLogin() async {
    // Validate email and password
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter both email and password');
      return;
    }

    try {
      final result = await ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text
      );

      // Check if the widget is still mounted before proceeding
      if (!mounted) return;

      if (result['success']) {
        // Navigate to home screen or dashboard
        _navigateToHome();
      } else {
        _showErrorSnackBar(result['message']);
      }
    } catch (e) {
      // Check if the widget is still mounted before showing error
      if (!mounted) return;
      _showErrorSnackBar('An error occurred. Please try again.');
    }
  }

  Future<void> _googleSignIn() async {
    try {
      final result = await ref.read(authProvider.notifier).googleSignIn();

      // Check if the widget is still mounted before proceeding
      if (!mounted) return;

      if (result['success']) {
        // Navigate to home screen or dashboard
        _navigateToHome();
      } else {
        _showErrorSnackBar(result['message']);
      }
    } catch (e) {
      // Check if the widget is still mounted before showing error
      if (!mounted) return;
      _showErrorSnackBar('An error occurred. Please try again.');
    }
  }

  void _navigateToHome() {
    // Replace with your actual home screen navigation
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _showErrorSnackBar(String message) {
    // Check if the widget is still mounted before showing SnackBar
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth state to react to loading
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: isLoading
                ? const CircularProgressIndicator()
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or App Title
                FlutterLogo(
                  size: 100,
                  style: FlutterLogoStyle.stacked,
                ),
                const SizedBox(height: 32),

                // Email TextField
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password TextField
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                const SizedBox(height: 16),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to forgot password screen
                      Navigator.of(context).pushNamed('/forgot-password');
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 16),

                // Login Button
                ElevatedButton(
                  onPressed: _emailLogin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('OR'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Google Sign-In Button
                OutlinedButton(
                  onPressed: _googleSignIn,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          'assets/images/google_logo.png',
                          height: 24,
                          width: 24
                      ),
                      const SizedBox(width: 10),
                      const Text('Sign in with Google'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Create Account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        // Navigate to registration screen
                        Navigator.of(context).pushNamed('/register');
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}