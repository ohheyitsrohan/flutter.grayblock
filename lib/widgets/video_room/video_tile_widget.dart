import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import '../../themes/app_colors.dart';

class VideoTileWidget extends StatefulWidget {
  final String name;
  final bool isHost;
  final bool isMuted;
  final bool isVideoOff;
  final Color backgroundColor;
  final VoidCallback onTap;
  final VideoTrack? videoTrack;
  final bool isDarkMode;

  const VideoTileWidget({
    Key? key,
    required this.name,
    required this.isHost,
    required this.isMuted,
    required this.isVideoOff,
    required this.backgroundColor,
    required this.onTap,
    this.videoTrack,
    this.isDarkMode = true,
  }) : super(key: key);

  @override
  State<VideoTileWidget> createState() => _VideoTileWidgetState();
}

class _VideoTileWidgetState extends State<VideoTileWidget> {
  @override
  void didUpdateWidget(covariant VideoTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoTrack != widget.videoTrack) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final placeholderBgColor = widget.isDarkMode
        ? const Color(0xFF2D2D2D)
        : const Color(0xFFE9ECEF);

    final placeholderIconColor = widget.isDarkMode
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.zero,
        ),
        margin: const EdgeInsets.all(2),
        child: Stack(
          children: [
            // Video or placeholder
            Positioned.fill(
              child: widget.isVideoOff || widget.videoTrack == null
                  ? Container(
                      color: placeholderBgColor,
                      child: Center(
                        child: widget.isVideoOff
                            ? Icon(
                                Icons.videocam_off,
                                size: 36,
                                color: placeholderIconColor,
                              )
                            : Text(
                                widget.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: FittedBox(
                        fit: BoxFit.cover, // Zoom and crop to fit square
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: 1280, // Default landscape resolution
                          height: 720,
                          child: VideoTrackRenderer(widget.videoTrack!),
                        ),
                      ),
                    ),
            ),

            // Bottom info bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.isHost ? '${widget.name} (Host)' : widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.isMuted)
                      const Icon(
                        Icons.mic_off,
                        color: AppColors.danger,
                        size: 16,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
