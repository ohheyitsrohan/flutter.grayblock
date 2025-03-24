import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import '../services/livekit_service.dart';

// LiveKit state class
class LiveKitState {
  final bool isConnected;
  final bool isConnecting;
  final bool isAudioEnabled;
  final bool isVideoEnabled;
  final String? error;
  final List<ParticipantInfo> participants;

  LiveKitState({
    this.isConnected = false,
    this.isConnecting = false,
    this.isAudioEnabled = false,
    this.isVideoEnabled = false,
    this.error,
    this.participants = const [],
  });

  LiveKitState copyWith({
    bool? isConnected,
    bool? isConnecting,
    bool? isAudioEnabled,
    bool? isVideoEnabled,
    String? error,
    List<ParticipantInfo>? participants,
  }) {
    return LiveKitState(
      isConnected: isConnected ?? this.isConnected,
      isConnecting: isConnecting ?? this.isConnecting,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      error: error ?? this.error,
      participants: participants ?? this.participants,
    );
  }
}

// Create a provider for LiveKitService
final liveKitServiceProvider = Provider<LiveKitService>((ref) {
  return LiveKitService();
});

// LiveKit state notifier
class LiveKitNotifier extends StateNotifier<LiveKitState> {
  final LiveKitService _liveKitService;

  LiveKitNotifier(this._liveKitService) : super(LiveKitState()) {
    _setupListeners();
  }

  void _setupListeners() {
    _liveKitService.roomEvents.listen((event) {
      switch (event.type) {
        case CustomRoomEventType.roomConnected:
          state = state.copyWith(
            isConnected: true,
            isConnecting: false,
            participants: _liveKitService.participants,
          );
          break;

        case CustomRoomEventType.roomDisconnected:
          state = state.copyWith(
            isConnected: false,
            isConnecting: false,
            participants: [],
          );
          break;

        case CustomRoomEventType.participantConnected:
        case CustomRoomEventType.participantDisconnected:
          state = state.copyWith(
            participants: _liveKitService.participants,
          );
          break;

        case CustomRoomEventType.trackSubscribed:
        case CustomRoomEventType.trackUnsubscribed:
          // ✅ Rebuild video tiles when video/audio tracks are subscribed/unsubscribed
          state = state.copyWith(
            participants: _liveKitService.participants,
          );
          break;

        case CustomRoomEventType.localTrackPublished:
        case CustomRoomEventType.localTrackUnpublished:
          state = state.copyWith(
            isAudioEnabled: _liveKitService.isAudioEnabled,
            isVideoEnabled: _liveKitService.isVideoEnabled,
          );
          break;

        case CustomRoomEventType.error:
          state = state.copyWith(
            error: event.error,
            isConnecting: false,
          );
          break;
      }
    });
  }

  Future<void> connect(String roomName, String identity) async {
    state = state.copyWith(isConnecting: true, error: null);

    try {
      await _liveKitService.connect(roomName, identity);
    } catch (e) {
      state = state.copyWith(
        isConnecting: false,
        error: e.toString(),
      );
    }
  }

  Future<void> disconnect() async {
    await _liveKitService.disconnect();
  }

  Future<void> toggleAudio() async {
    final isEnabled = await _liveKitService.toggleAudio();
    state = state.copyWith(isAudioEnabled: isEnabled);
  }

  Future<void> toggleVideo() async {
    final isEnabled = await _liveKitService.toggleVideo();
    state = state.copyWith(isVideoEnabled: isEnabled);
  }

  @override
  void dispose() {
    _liveKitService.dispose();
    super.dispose();
  }
}

// Create a StateNotifierProvider for LiveKit state
final liveKitProvider = StateNotifierProvider<LiveKitNotifier, LiveKitState>((ref) {
  final liveKitService = ref.watch(liveKitServiceProvider);
  return LiveKitNotifier(liveKitService);
});
