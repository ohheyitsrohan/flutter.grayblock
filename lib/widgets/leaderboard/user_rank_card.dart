// lib/widgets/leaderboard/user_rank_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/leaderboard_provider.dart';
import '../../providers/auth_provider.dart';
import '../../themes/app_colors.dart';

class UserRankCard extends ConsumerWidget {
  final String leaderboardType;
  final String timeFilter;

  const UserRankCard({
    Key? key,
    required this.leaderboardType,
    required this.timeFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state for user data
    final authState = ref.watch(authProvider);
    final userImage = authState.user?.profileImage;

    // Watch leaderboard state
    final leaderboardState = ref.watch(leaderboardProvider);
    final userRank = leaderboardState.userRank;
    final userStats = ref.read(leaderboardProvider.notifier).getUserStatsFormatted();

    // Calculate percentile if available
    String percentile = '-';
    int totalUsers = leaderboardState.users.length;

    if (leaderboardState.status == LeaderboardStatus.loaded &&
        totalUsers > 0 &&
        userRank != null) {
      // Calculate percentile (if user has a rank)
      final double rankPercentage = (userRank / totalUsers) * 100;
      if (rankPercentage <= 100) {
        percentile = 'Top ${rankPercentage.round()}%';
      }
    }

    // If we don't have the user rank data yet and we're not already loading, fetch it
    if (userRank == null &&
        leaderboardState.status != LeaderboardStatus.loading &&
        leaderboardState.status != LeaderboardStatus.initial) {
      // Trigger a refresh to get updated data including user stats
      Future.microtask(() => ref.read(leaderboardProvider.notifier).fetchLeaderboard(
        leaderboardType: leaderboardType,
        timeFilter: timeFilter,
      ));
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left section - Rank info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Rank',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary(context),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  // Show loading indicator if loading
                  if (leaderboardState.status == LeaderboardStatus.loading)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.text(context),
                      ),
                    )
                  else
                    Text(
                      userRank != null ? '#$userRank' : '--',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text(context),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.iconBackground(context, AppColors.primary),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      percentile,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right section - Avatar and score
          Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25 - 2),
                  child: userImage != null && userImage.isNotEmpty
                      ? Image.network(
                    userImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar(context);
                    },
                  )
                      : _buildDefaultAvatar(context),
                ),
              ),
              const SizedBox(height: 8),
              // Show loading indicator if loading
              if (leaderboardState.status == LeaderboardStatus.loading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              else
                Text(
                  userStats,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    return Container(
      color: AppColors.inactiveControl(context),
      child: Icon(
        Icons.person,
        color: AppColors.primary,
        size: 30,
      ),
    );
  }
}