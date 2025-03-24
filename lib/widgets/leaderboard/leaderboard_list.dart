// lib/widgets/leaderboard/leaderboard_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/leaderboard_provider.dart';
import '../../models/leaderboard_user.dart';
import '../../themes/app_colors.dart';

class LeaderboardList extends ConsumerWidget {
  final String leaderboardType;
  final String timeFilter;

  const LeaderboardList({
    Key? key,
    required this.leaderboardType,
    required this.timeFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch leaderboard state
    final leaderboardState = ref.watch(leaderboardProvider);

    // Fetch leaderboard when widget builds with new parameters
    if (leaderboardState.currentType != leaderboardType ||
        leaderboardState.currentTimeFilter != timeFilter) {
      // Only update if we're not already loading
      if (leaderboardState.status != LeaderboardStatus.loading) {
        // Use Future.microtask to avoid build-time setState
        Future.microtask(() => ref.read(leaderboardProvider.notifier).fetchLeaderboard(
          leaderboardType: leaderboardType,
          timeFilter: timeFilter,
        ));
      }
    }

    // Show loading indicator if loading
    if (leaderboardState.status == LeaderboardStatus.loading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Show error message if error
    if (leaderboardState.status == LeaderboardStatus.error) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load leaderboard',
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  leaderboardState.errorMessage ?? 'Unknown error',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(leaderboardProvider.notifier).fetchLeaderboard(
                      leaderboardType: leaderboardType,
                      timeFilter: timeFilter,
                    );
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Get users from state
    final List<LeaderboardUser> users = leaderboardState.users;

    // Show empty state if no users
    if (users.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.people_outline,
                  color: AppColors.textSecondary(context),
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'No users on the leaderboard yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: AppColors.background(context),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.divider(context),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    'Rank',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'User',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    leaderboardType == 'studyHours' ? 'Hours' : 'Streak',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // User List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                // Special styling for top 3
                final bool isTopThree = index < 3;
                final List<Color> rankColors = [
                  const Color(0xFFFFD700), // Gold
                  const Color(0xFFC0C0C0), // Silver
                  const Color(0xFFCD7F32), // Bronze
                ];

                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: isTopThree
                        ? AppColors.background(context)
                        : AppColors.card(context),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.divider(context),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Rank number
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isTopThree
                              ? rankColors[index]
                              : AppColors.inactiveControl(context),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 15),
                        child: Text(
                          '${user.rank}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isTopThree
                                ? Colors.white
                                : AppColors.textSecondary(context),
                          ),
                        ),
                      ),

                      // User avatar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          user.avatar,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 40,
                              height: 40,
                              color: AppColors.inactiveControl(context),
                              child: Icon(
                                Icons.person,
                                color: AppColors.textSecondary(context),
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 15),

                      // Username
                      Expanded(
                        child: Text(
                          user.username,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.text(context),
                          ),
                        ),
                      ),

                      // Score (hours or streak days)
                      SizedBox(
                        width: 80,
                        child: Text(
                          leaderboardType == 'studyHours'
                              ? '${user.studyHours} hrs'
                              : '${user.streakDays} days',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}