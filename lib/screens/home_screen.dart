// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weekly_data.dart';
import '../providers/auth_provider.dart';
import '../providers/stats_provider.dart';
import '../providers/leaderboard_provider.dart'; // Import leaderboard provider
import '../widgets/header_widget.dart';
import '../widgets/streak_section.dart';
import '../widgets/info_card.dart';
import '../widgets/focus_rooms_section.dart';
import '../widgets/weekly_goal_section.dart';
import '../widgets/session_stats_widget.dart';
import '../widgets/weekly_progress_chart.dart';
import '../widgets/modals/goal_setting_modal.dart';
import '../widgets/modals/filter_modal.dart';
import '../widgets/modals/profile_modal.dart';
import '../widgets/auth/login_button.dart';
import '../themes/app_colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  // Default values (will be replaced with API data)
  String userName = "User";
  int streakMinutes = 0;
  int streakGoal = 30;
  int leaderboardRank = 0;
  double thirtyDayAvg = 0;
  double todayHours = 0;
  int sessionsCompleted = 0;
  String avgSessionTime = "0 min";
  int longestStreak = 0;

  // Weekly progress data
  late List<WeeklyData> weeklyData;

  // Weekly goal state
  int weeklyGoal = 20;
  String tempGoal = '20';
  String filterOption = 'Last 7 days';

  // Controllers for animations
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _streakAnimation;
  late Animation<double> _cardOpacityAnimation;
  late Animation<double> _cardTranslateAnimation;

  // Modal visibility states
  bool isGoalModalVisible = false;
  bool isFilterModalVisible = false;

  @override
  void initState() {
    super.initState();

    // Initialize with empty data
    weeklyData = [];

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _streakAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _cardOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    ));

    _cardTranslateAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Fetch real data when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fetch data from APIs
  Future<void> _fetchData() async {
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated) {
      // Fetch stats and goals
      await ref.read(statsProvider.notifier).fetchStatsAndGoals();

      // Fetch leaderboard data to get user rank
      await ref.read(leaderboardProvider.notifier).fetchLeaderboard(
        leaderboardType: 'studyHours',
        timeFilter: 'allTime',
      );

      // Get data from providers
      final statsState = ref.read(statsProvider);
      final leaderboardState = ref.read(leaderboardProvider);

      if (statsState.stats != null && statsState.goals != null) {
        final stats = statsState.stats!;
        final goals = statsState.goals!;

        setState(() {
          // Update values with real data
          streakMinutes = stats.dailyProgress.totalMinutes;
          streakGoal = stats.dailyProgress.goalMinutes;
          weeklyGoal = goals.weeklyGoalHours;
          tempGoal = weeklyGoal.toString();
          thirtyDayAvg = stats.thirtyDaysStats.averageDailyHours;
          todayHours = stats.todayStats.totalHours;
          sessionsCompleted = stats.averageSessionTime.totalSessions;
          avgSessionTime = stats.averageSessionTime.formattedAvgTime;
          weeklyData = statsState.weeklyData;

          // Get longest streak from stats API
          longestStreak = stats.streak?.longestStreak ?? 0;

          // Get rank from leaderboard API
          leaderboardRank = leaderboardState.userRank ?? 0;

          // Update animations with real data
          _progressAnimation = Tween<double>(
            begin: 0.0,
            end: _calculateProgressPercentage(),
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ));

          _streakAnimation = Tween<double>(
            begin: 0.0,
            end: (streakMinutes / streakGoal).clamp(0.0, 1.0),
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ));

          // Restart animations with new values
          _animationController.forward(from: 0.0);
        });
      }
    }
  }

  double _calculateProgressPercentage() {
    final double totalHoursThisWeek = weeklyData.isEmpty ? 0 : WeeklyData.getTotalHours(weeklyData);
    return (totalHoursThisWeek / weeklyGoal).clamp(0.0, 1.0);
  }

  void _showGoalSettingModal() {
    setState(() => isGoalModalVisible = true);
  }

  void _showFilterModal() {
    setState(() => isFilterModalVisible = true);
  }

  void _showProfileModal() {
    final authState = ref.read(authProvider);

    if (authState.isAuthenticated) {
      // Show modal using showModalBottomSheet to ensure it appears above navigation bar
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ProfileModal(
          userName: authState.user?.name ?? userName,
          onDismiss: () => Navigator.pop(context),
          onProfileSelected: () {
            Navigator.pop(context);
            _handleProfileOptionSelected('profile');
          },
          onSettingsSelected: () {
            Navigator.pop(context);
            _handleProfileOptionSelected('settings');
          },
          onLogoutSelected: () {
            Navigator.pop(context);
            _handleProfileOptionSelected('logout');
          },
        ),
      );
    } else {
      // If not authenticated, show login screen
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushNamed('/login');
  }

  void _hideModals() {
    setState(() {
      isGoalModalVisible = false;
      isFilterModalVisible = false;
    });
  }

  void _handleProfileOptionSelected(String option) {
    // Handle navigation based on selected option
    switch (option) {
      case 'profile':
      // Use the named route navigation
        Navigator.of(context).pushNamed('/profile');
        break;
      case 'settings':
      // Use the named route navigation
        Navigator.of(context).pushNamed('/settings');
        break;
      case 'logout':
        ref.read(authProvider.notifier).logout();
        break;
    }
  }

  void _updateWeeklyGoal(int newGoal) async {
    if (newGoal > 0) {
      // Update API first
      await ref.read(statsProvider.notifier).updateWeeklyGoal(newGoal);

      setState(() {
        weeklyGoal = newGoal;
        isGoalModalVisible = false;

        // Update progress animation
        _progressAnimation = Tween<double>(
          begin: _progressAnimation.value,
          end: _calculateProgressPercentage(),
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));

        _animationController.forward(from: 0.0);
      });
    }
  }

  void _updateFilterOption(String option) {
    setState(() {
      filterOption = option;
      isFilterModalVisible = false;

      // Map UI filter option to API time range
      final timeRange = option == 'Last 7 days' ? 'week' :
      option == 'This Month' ? 'month' : 'all';

      // Update time range in provider
      ref.read(statsProvider.notifier).changeTimeRange(timeRange);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth * 0.7;
    final double totalHoursThisWeek = weeklyData.isEmpty ? 0 : WeeklyData.getTotalHours(weeklyData);
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.isAuthenticated;

    // Watch for stats loading state
    final statsState = ref.watch(statsProvider);
    final leaderboardState = ref.watch(leaderboardProvider);
    final isLoading = statsState.status == StatsStatus.loading ||
        leaderboardState.status == LeaderboardStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              children: [
                _buildMainContent(screenWidth, cardWidth, totalHoursThisWeek, isAuthenticated, isLoading),
                if (isGoalModalVisible)
                  GoalSettingModal(
                    tempGoal: tempGoal,
                    onCancel: _hideModals,
                    onSave: _updateWeeklyGoal,
                    onTempGoalChanged: (value) => setState(() => tempGoal = value),
                  ),
                if (isFilterModalVisible)
                  FilterModal(
                    currentOption: filterOption,
                    onSelect: _updateFilterOption,
                    onClose: _hideModals,
                  ),
              ],
            );
          },
        ),
      ),
      // Add a floating action button for quick access to login
      floatingActionButton: !isAuthenticated
          ? FloatingActionButton(
        onPressed: _navigateToLogin,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.login),
      )
          : FloatingActionButton(
        onPressed: _fetchData, // Refresh button for authenticated users
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildMainContent(double screenWidth, double cardWidth, double totalHoursThisWeek, bool isAuthenticated, bool isLoading) {
    final authState = ref.watch(authProvider);
    final statsState = ref.watch(statsProvider);

    // Show loading indicator if first load
    if (isLoading && weeklyData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              // Header Section with avatar that shows profile modal when tapped
              HeaderWidget(
                userName: isAuthenticated
                    ? authState.user?.name ?? userName
                    : "Guest",
                onAvatarTap: _showProfileModal,
                isAuthenticated: isAuthenticated,
                onLogin: _navigateToLogin,
              ),

              // Login button for unauthenticated users
              if (!isAuthenticated)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  child: LoginButton(onLogin: _navigateToLogin),
                ),

              // Loading indicator for authenticated users during refresh
              if (isAuthenticated && isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

              // Streak Section
              StreakSection(
                streakMinutes: streakMinutes,
                streakGoal: streakGoal,
                animation: _streakAnimation,
                cardAnimation: _cardOpacityAnimation,
                translateAnimation: _cardTranslateAnimation,
              ),

              // Horizontal Cards
              SizedBox(
                height: 135, // Increased slightly for shadow
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20.0, right: 5.0, bottom: 5.0),
                  children: [
                    // Leaderboard Card - Shows rank and best streak
                    InfoCard(
                      icon: Icons.emoji_events_outlined,
                      iconColor: const Color(0xFF8B5CF6),
                      iconBackground: AppColors.iconBackground(context, const Color(0xFF8B5CF6)),
                      title: 'Leaderboard',
                      value: 'Rank #${leaderboardRank > 0 ? leaderboardRank : '—'}',
                      subtext: 'Best streak: ${longestStreak > 0 ? longestStreak : '—'} days',
                      cardWidth: cardWidth,
                      opacityAnimation: _cardOpacityAnimation,
                      translateAnimation: _cardTranslateAnimation,
                      onTap: () => Navigator.of(context).pushNamed('/leaderboard'),
                    ),

                    // 30 Day Average Card
                    InfoCard(
                      icon: Icons.calendar_month_outlined,
                      iconColor: const Color(0xFFEC4899),
                      iconBackground: AppColors.iconBackground(context, const Color(0xFFEC4899)),
                      title: '30-Day Average',
                      value: '$thirtyDayAvg hours',
                      subtext: statsState.stats != null ?
                      '${statsState.stats!.thirtyDaysStats.totalHours} total hours' :
                      'Start tracking today',
                      cardWidth: cardWidth,
                      opacityAnimation: _cardOpacityAnimation,
                      translateAnimation: _cardTranslateAnimation,
                    ),

                    // Today's Hours Card
                    InfoCard(
                      icon: Icons.access_time_outlined,
                      iconColor: const Color(0xFF0EA5E9),
                      iconBackground: AppColors.iconBackground(context, const Color(0xFF0EA5E9)),
                      title: 'Today',
                      value: '$todayHours hours',
                      subtext: statsState.stats != null ?
                      '${statsState.stats!.todayStats.sessionCount} sessions today' :
                      'No sessions yet',
                      cardWidth: cardWidth,
                      opacityAnimation: _cardOpacityAnimation,
                      translateAnimation: _cardTranslateAnimation,
                    ),
                  ],
                ),
              ),

              // Focus Rooms Section
              FocusRoomsSection(
                opacityAnimation: _cardOpacityAnimation,
                translateAnimation: _cardTranslateAnimation,
              ),

              // Weekly Goal Section
              WeeklyGoalSection(
                weeklyGoal: weeklyGoal,
                totalHoursThisWeek: totalHoursThisWeek,
                progressAnimation: _progressAnimation,
                opacityAnimation: _cardOpacityAnimation,
                translateAnimation: _cardTranslateAnimation,
                onEditGoal: _showGoalSettingModal,
              ),

              // Session Stats
              SessionStatsWidget(
                sessionsCompleted: sessionsCompleted,
                avgSessionTime: avgSessionTime,
                opacityAnimation: _cardOpacityAnimation,
                translateAnimation: _cardTranslateAnimation,
              ),

              // Weekly Progress - Bar Chart
              WeeklyProgressChart(
                weeklyData: weeklyData,
                filterOption: filterOption,
                progressAnimation: _progressAnimation,
                opacityAnimation: _cardOpacityAnimation,
                translateAnimation: _cardTranslateAnimation,
                onFilterTap: _showFilterModal,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}