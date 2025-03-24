import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

class RoomControlsWidget extends StatelessWidget {
  final bool isMuted;
  final bool isVideoOff;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleVideo;
  final VoidCallback onExit;
  final bool isDarkMode;

  const RoomControlsWidget({
    Key? key,
    required this.isMuted,
    required this.isVideoOff,
    required this.onToggleMute,
    required this.onToggleVideo,
    required this.onExit,
    this.isDarkMode = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mute/Unmute button
            _buildControlButton(
              icon: isMuted ? Icons.mic_off : Icons.mic,
              isActive: isMuted,
              onPressed: onToggleMute,
              activeColor: AppColors.danger,
              inactiveColor: AppColors.primary,
            ),

            const SizedBox(width: 16),

            // Video on/off button
            _buildControlButton(
              icon: isVideoOff ? Icons.videocam_off : Icons.videocam,
              isActive: isVideoOff,
              onPressed: onToggleVideo,
              activeColor: AppColors.danger,
              inactiveColor: AppColors.primary,
            ),

            const SizedBox(width: 16),

            // Exit button
            _buildControlButton(
              icon: Icons.call_end,
              isActive: true,
              onPressed: onExit,
              activeColor: AppColors.danger,
              inactiveColor: AppColors.danger,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (isActive ? activeColor : inactiveColor).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Ink(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? activeColor : inactiveColor,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}