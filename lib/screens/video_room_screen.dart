import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import '../providers/livekit_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/video_room/video_tile_widget.dart';
import '../widgets/video_room/room_controls_widget.dart';
import '../widgets/video_room/exit_confirmation_dialog.dart';
import '../themes/app_colors.dart';
import 'dart:async';

class VideoRoomScreen extends ConsumerStatefulWidget {
  final String roomName;
  final String roomId;

  const VideoRoomScreen({
    Key? key,
    required this.roomName,
    required this.roomId,
  }) : super(key: key);

  @override
  ConsumerState<VideoRoomScreen> createState() => _VideoRoomScreenState();
}

class _VideoRoomScreenState extends ConsumerState<VideoRoomScreen> {
  bool controlsVisible = true;
  bool isLandscape = false;
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();
    _resetControlsTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      final identity = user?.id.toString() ?? 'anonymous-${DateTime.now().millisecondsSinceEpoch}';
      final normalizedRoomName = widget.roomName.trim().toLowerCase().replaceAll(' ', '-');
      debugPrint('🔗 Joining LiveKit room: $normalizedRoomName with identity: $identity');
      ref.read(liveKitProvider.notifier).connect(normalizedRoomName, identity);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkOrientation();
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    ref.read(liveKitProvider.notifier).disconnect();
    super.dispose();
  }

  void _checkOrientation() {
    final size = MediaQuery.of(context).size;
    setState(() {
      isLandscape = size.width > size.height;
    });
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          controlsVisible = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      controlsVisible = !controlsVisible;
      if (controlsVisible) {
        _resetControlsTimer();
      }
    });
  }

  void _toggleMute() async {
    await ref.read(liveKitProvider.notifier).toggleAudio();
    _resetControlsTimer();
  }

  void _toggleVideo() async {
    await ref.read(liveKitProvider.notifier).toggleVideo();
    _resetControlsTimer();
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => ExitConfirmationDialog(
        onExit: _exitRoom,
      ),
    );
  }

  void _exitRoom() {
    Navigator.pop(context);
  }

  Color _getParticipantColor(String id) {
    const colors = [
      Color(0xFF4361EE),
      Color(0xFF3A0CA3),
      Color(0xFF7209B7),
      Color(0xFFF72585),
      Color(0xFF4CC9F0),
      Color(0xFF4895EF),
      Color(0xFF560BAD),
      Color(0xFFB5179E),
    ];

    int hash = 0;
    for (int i = 0; i < id.length; i++) {
      hash += id.codeUnitAt(i);
    }

    return colors[hash % colors.length];
  }

  // Helper method to extract the video track from any participant.
  VideoTrack? _getVideoTrack(Participant participant) {
    for (final publication in participant.trackPublications.values) {
      if (publication.kind == TrackType.VIDEO && publication.track is VideoTrack) {
        return publication.track as VideoTrack;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final liveKitState = ref.watch(liveKitProvider);
    final numColumns = isLandscape ? 4 : 2;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SafeArea(
            child: GestureDetector(
              onTap: _toggleControls,
              child: Stack(
                children: [
                  // LiveKit video tiles
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 80,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: numColumns,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: liveKitState.participants.length,
                      itemBuilder: (context, index) {
                        final info = liveKitState.participants[index];
                        final participant = info.participant;
                        final name = participant.identity;
                        final isMuted = participant.isSpeaking == false;
                        final isVideoOff = !participant.isCameraEnabled();
                        final videoTrack = _getVideoTrack(participant);

                        return VideoTileWidget(
                          key: ValueKey('${participant.identity}-${videoTrack?.sid ?? ''}'), // 👈 This line ensures rebuild
                          name: name,
                          isHost: info.isHost,
                          isMuted: isMuted,
                          isVideoOff: isVideoOff,
                          backgroundColor: _getParticipantColor(name),
                          onTap: _toggleControls,
                          videoTrack: videoTrack,
                          isDarkMode: isDarkMode,
                        );
                      },
                    ),
                  ),

                  if (controlsVisible)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.surface(context).withOpacity(0.9),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppColors.text(context),
                              ),
                              onPressed: _showExitConfirmation,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "Room: ${widget.roomName.replaceAll('-', ' ').toUpperCase()}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (controlsVisible)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: RoomControlsWidget(
                        isMuted: !liveKitState.isAudioEnabled,
                        isVideoOff: !liveKitState.isVideoEnabled,
                        onToggleMute: _toggleMute,
                        onToggleVideo: _toggleVideo,
                        onExit: _showExitConfirmation,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
