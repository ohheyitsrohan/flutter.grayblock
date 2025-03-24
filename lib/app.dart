// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'screens/room_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'themes/app_theme.dart';
import 'main.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the theme mode
    final themeMode = ref.watch(themeModeProvider);
    final isDark = ref.watch(isDarkModeProvider);

    // Set system UI overlay based on theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Study Focus App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const MainNavigationScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const MainNavigationScreen(),
        '/profile': (context) => ProfileScreen(
          onBack: () => Navigator.of(context).pop(),
        ),
        '/settings': (context) => SettingsScreen(
          onBack: () => Navigator.of(context).pop(),
        ),
        '/leaderboard': (context) => LeaderboardScreen(
          onBack: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
      },
    );
  }
}

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _selectedIndex = 0;
  String _currentScreen = 'main'; // 'main', 'profile', or 'settings'

  @override
  void initState() {
    super.initState();
  }

  void navigateToScreen(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _navigateToMain() {
    setState(() {
      _currentScreen = 'main';
    });
  }

  void _handleLogout() async {
    // Get the AuthNotifier and call logout
    await ref.read(authProvider.notifier).logout();

    setState(() {
      _currentScreen = 'main';
      _selectedIndex = 0; // Reset to home tab
    });
  }

  void _showLoginScreen() {
    Navigator.pushNamed(context, '/login');
  }

  // Determine which content to show based on current screen and auth state
  Widget _getScreenContent(BuildContext context) {
    // Read the auth state
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.isAuthenticated;

    // Handle profile and settings screens
    if (_currentScreen == 'profile') {
      if (isAuthenticated) {
        return ProfileScreen(onBack: _navigateToMain);
      } else {
        // If trying to access profile while logged out, show login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/login');
        });
        return const HomeScreen(); // Show home screen momentarily before redirect
      }
    }

    if (_currentScreen == 'settings') {
      if (isAuthenticated) {
        return SettingsScreen(onBack: _navigateToMain);
      } else {
        // If trying to access settings while logged out, show login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/login');
        });
        return const HomeScreen(); // Show home screen momentarily before redirect
      }
    }

    // Main screens based on tab selection
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const FeedScreen();
      case 2:
        return const RoomScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always return the main scaffold with bottom navigation
    return Scaffold(
      body: _getScreenContent(context),
      bottomNavigationBar: _currentScreen == 'main'
          ? BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            activeIcon: Icon(Icons.newspaper),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Rooms',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
      )
          : null, // Hide bottom navigation when not on main screens
    );
  }
}