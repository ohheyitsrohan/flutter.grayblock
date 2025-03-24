import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/leaderboard/leaderboard_filter_modal.dart';
import '../widgets/leaderboard/leaderboard_type_selector.dart';
import '../widgets/leaderboard/user_rank_card.dart';
import '../widgets/leaderboard/leaderboard_list.dart';
import '../providers/leaderboard_provider.dart';
import '../themes/app_colors.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const LeaderboardScreen({
    Key? key,
    required this.onBack,
  }) : super(key: key);

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> with SingleTickerProviderStateMixin {
  bool _filterModalVisible = false;
  late AnimationController _animationController;
  late Animation<double> _headerOpacityAnimation;
  late Animation<double> _listTranslateAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Define animations
    _headerOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _listTranslateAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Start animation
    _animationController.forward();

    // Initialize leaderboard data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final leaderboardState = ref.read(leaderboardProvider);
      ref.read(leaderboardProvider.notifier).fetchLeaderboard(
        leaderboardType: leaderboardState.currentType,
        timeFilter: leaderboardState.currentTimeFilter,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showFilterModal() {
    setState(() {
      _filterModalVisible = true;
    });
  }

  void _hideFilterModal() {
    setState(() {
      _filterModalVisible = false;
    });
  }

  void _updateTimeFilter(String filter) {
    setState(() {
      _filterModalVisible = false;
    });
    ref.read(leaderboardProvider.notifier).updateTimeFilter(filter);
  }

  void _updateLeaderboardType(String type) {
    ref.read(leaderboardProvider.notifier).updateLeaderboardType(type);
  }

  @override
  Widget build(BuildContext context) {
    // Watch leaderboard state
    final leaderboardState = ref.watch(leaderboardProvider);
    final currentType = leaderboardState.currentType;
    final currentTimeFilter = leaderboardState.currentTimeFilter;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Header
                FadeTransition(
                  opacity: _headerOpacityAnimation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppColors.text(context),
                              ),
                              onPressed: widget.onBack,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Leaderboard',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text(context),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: _showFilterModal,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.iconBackground(context, AppColors.primary),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  currentTimeFilter == 'allTime'
                                      ? 'All Time'
                                      : currentTimeFilter == 'monthly'
                                      ? 'Monthly'
                                      : 'Weekly',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Leaderboard Type Selector
                FadeTransition(
                  opacity: _headerOpacityAnimation,
                  child: LeaderboardTypeSelector(
                    currentType: currentType,
                    onTypeSelected: _updateLeaderboardType,
                  ),
                ),

                // Your Rank Card
                FadeTransition(
                  opacity: _headerOpacityAnimation,
                  child: UserRankCard(
                    leaderboardType: currentType,
                    timeFilter: currentTimeFilter,
                  ),
                ),

                // Leaderboard List
                Expanded(
                  child: AnimatedBuilder(
                    animation: _listTranslateAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _listTranslateAnimation.value),
                        child: LeaderboardList(
                          leaderboardType: currentType,
                          timeFilter: currentTimeFilter,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Filter Modal
            if (_filterModalVisible)
              LeaderboardFilterModal(
                currentFilter: currentTimeFilter,
                onFilterSelected: _updateTimeFilter,
                onClose: _hideFilterModal,
              ),
          ],
        ),
      ),
    );
  }
}