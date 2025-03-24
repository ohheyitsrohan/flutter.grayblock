import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:livekit_client/livekit_client.dart';
import '../services/auth_service.dart';
import '../config/api_config.dart';

// Custom Room event types (separate from LiveKit's own RoomEvent)
enum CustomRoomEventType {
  roomConnected,
  roomDisconnected,
  participantConnected,
  participantDisconnected,
  trackSubscribed,
  trackUnsubscribed,
  localTrackPublished,
  localTrackUnpublished,
  error,
}

// Custom Room event class
class CustomRoomEvent {
  final CustomRoomEventType type;
  final Room? room;
  final Participant? participant;
  final TrackPublication? publication;
  final Track? track;
  final String? error;
  final DisconnectReason? disconnectReason;

  CustomRoomEvent({
    required this.type,
    this.room,
    this.participant,
    this.publication,
    this.track,
    this.error,
    this.disconnectReason,
  });
}

// Participant info class for UI
class ParticipantInfo {
  final Participant participant;
  final bool isLocal;
  final bool isHost;

  ParticipantInfo({
    required this.participant,
    required this.isLocal,
    this.isHost = false,
  });
}

class LiveKitService {
  final AuthService _authService = AuthService();
  Room? _room;
  Room? get room => _room;
  EventsListener<RoomEvent>? _listener;

  // Event streams
  final _roomEventStreamController = StreamController<CustomRoomEvent>.broadcast();
  Stream<CustomRoomEvent> get roomEvents => _roomEventStreamController.stream;

  // Track local participant state
  LocalParticipant? _localParticipant;
  LocalParticipant? get localParticipant => _localParticipant;

  // Track audio/video state
  bool _isAudioEnabled = false;
  bool _isVideoEnabled = false;
  bool get isAudioEnabled => _isAudioEnabled;
  bool get isVideoEnabled => _isVideoEnabled;

  // List of participants for UI
  List<ParticipantInfo> _participants = [];
  List<ParticipantInfo> get participants => _participants;

  // Dispose resources
  Future<void> dispose() async {
    await _roomEventStreamController.close();
    _listener?.dispose();
    await _room?.disconnect();
    _room = null;
  }

  // Get token from server
  Future<String> _getToken(String roomName, String identity) async {
    try {
      final authHeaders = await _authService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}//token'),
        headers: {
          ...authHeaders,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'roomName': roomName,
          'identity': identity,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['token'];
      } else {
        throw Exception('Failed to get token: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error getting token: $e');
      // Fallback to using a demo token service for testing
      if (kDebugMode) {
        // This is a fallback for development/testing only!
        final livekitUrl = dotenv.env['LIVEKIT_URL'] ?? 'https://livekit.grayblock.io';
        final apiKey = dotenv.env['LIVEKIT_API_KEY'] ?? 'mykey1234';
        final apiSecret = dotenv.env['LIVEKIT_API_SECRET'] ?? 'mysecretshouldbelongerthan32wordssohereiamtypingsomeshitthatidontknowihope32wordsaredonenoworiwillhavetokeeptypingshouldistoplocal';

        final demoResponse = await http.post(
          Uri.parse('https://demos.livekit.io/api/token'),
          body: {
            'url': livekitUrl,
            'api_key': apiKey,
            'api_secret': apiSecret,
            'room': roomName,
            'username': identity,
          },
        );

        if (demoResponse.statusCode == 200) {
          return demoResponse.body;
        }
      }

      throw Exception('Failed to get LiveKit token');
    }
  }

  // Connect to a LiveKit room
  Future<void> connect(String roomName, String identity) async {
    try {
      // Get LiveKit token
      final token = await _getToken(roomName, identity);
      debugPrint('Connecting to LiveKit room: $roomName as $identity');

      // Initialize the room
      _room = Room();

      // Set up event listeners
      _setupRoomListeners(_room!);

      // Connect to the LiveKit server
      final connectOptions = RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        // Set to false to manually control subscription later
        defaultVideoPublishOptions: const VideoPublishOptions(
          simulcast: true,
        ),
        defaultAudioPublishOptions: const AudioPublishOptions(),
      );

      final livekitUrl = dotenv.env['LIVEKIT_URL'] ?? 'https://livekit.grayblock.io';
      await _room!.connect(livekitUrl, token, roomOptions: connectOptions);

      _localParticipant = _room!.localParticipant;

      // Update participants list
      _updateParticipants();

      // Fire connected event
      _roomEventStreamController.add(CustomRoomEvent(
        type: CustomRoomEventType.roomConnected,
        room: _room,
      ));

    } catch (e) {
      debugPrint('Error connecting to LiveKit: $e');
      _roomEventStreamController.add(CustomRoomEvent(
        type: CustomRoomEventType.error,
        error: e.toString(),
      ));
      rethrow;
    }
  }

  // Disconnect from the room
  Future<void> disconnect() async {
    try {
      await _room?.disconnect();
      _room = null;
      _localParticipant = null;
      _participants = [];

      _roomEventStreamController.add(CustomRoomEvent(
        type: CustomRoomEventType.roomDisconnected,
      ));
    } catch (e) {
      debugPrint('Error disconnecting from LiveKit: $e');
    }
  }

  // Toggle local audio
  Future<bool> toggleAudio() async {
    try {
      if (_localParticipant == null) return false;

      if (_isAudioEnabled) {
        // Disable audio
        await _localParticipant!.setMicrophoneEnabled(false);
      } else {
        // Enable audio
        await _localParticipant!.setMicrophoneEnabled(true);
      }

      _isAudioEnabled = !_isAudioEnabled;
      return _isAudioEnabled;
    } catch (e) {
      debugPrint('Error toggling audio: $e');
      return _isAudioEnabled;
    }
  }

  // Toggle local video
  Future<bool> toggleVideo() async {
    try {
      if (_localParticipant == null) return false;

      if (_isVideoEnabled) {
        // Disable video
        await _localParticipant!.setCameraEnabled(false);
      } else {
        // Enable video
        await _localParticipant!.setCameraEnabled(true);
      }

      _isVideoEnabled = !_isVideoEnabled;
      return _isVideoEnabled;
    } catch (e) {
      debugPrint('Error toggling video: $e');
      return _isVideoEnabled;
    }
  }

  // Set up room event listeners
  void _setupRoomListeners(Room room) {
    // Create event listener from the room
    final listener = room.createListener();

    // Store listener for cleanup
    _listener = listener;

    // Register event handlers one by one
    listener.on<RoomDisconnectedEvent>((event) {
      debugPrint('Room disconnected: ${event.reason}');
      _roomEventStreamController.add(CustomRoomEvent(
        type: CustomRoomEventType.roomDisconnected,
        disconnectReason: event.reason,
      ));
    });

    listener.on<ParticipantConnectedEvent>((event) {
      debugPrint('Participant connected: ${event.participant.identity}');
      _updateParticipants();
      _roomEventStreamController.add(CustomRoomEvent(
        type: CustomRoomEventType.participantConnected,
        participant: event.participant,
      ));
    });

    listener.on<ParticipantDisconnectedEvent>((event) {
      debugPrint('Participant disconnected: ${event.participant.identity}');
      _updateParticipants();
      _roomEventStreamController.add(CustomRoomEvent(
        type: CustomRoomEventType.participantDisconnected,
        participant: event.participant,
      ));
    });

    listener.on<TrackSubscribedEvent>((event) {
      debugPrint('Track subscribed: ${event.publication.kind} from ${event.participant.identity}');
      _roomEventStreamController.add(CustomRoomEvent(
        type: CustomRoomEventType.trackSubscribed,
        participant: event.participant,
        publication: event.publication,
        track: event.track,
      ));
    });

    listener.on<TrackUnsubscribedEvent>((event) {
      debugPrint('Track unsubscribed: ${event.publication.kind} from ${event.participant.identity}');
      _roomEventStreamController.add(CustomRoomEvent(
        type: CustomRoomEventType.trackUnsubscribed,
        participant: event.participant,
        publication: event.publication,
        track: event.track,
      ));
    });

    listener.on<LocalTrackPublishedEvent>((event) {
      final kind = event.publication.kind;
      debugPrint('Local track published: $kind');

      if (kind == TrackType.AUDIO) {
        _isAudioEnabled = true;
      } else if (kind == TrackType.VIDEO) {
        _isVideoEnabled = true;
      }

      _roomEventStreamController.add(CustomRoomEvent(
        type: CustomRoomEventType.localTrackPublished,
        publication: event.publication,
      ));
    });

    listener.on<LocalTrackUnpublishedEvent>((event) {
      final kind = event.publication.kind;
      debugPrint('Local track unpublished: $kind');

      if (kind == TrackType.AUDIO) {
        _isAudioEnabled = false;
      } else if (kind == TrackType.VIDEO) {
        _isVideoEnabled = false;
      }

      _roomEventStreamController.add(CustomRoomEvent(
        type: CustomRoomEventType.localTrackUnpublished,
        publication: event.publication,
      ));
    });
  }

  // Update the list of participants
  void _updateParticipants() {
    if (_room == null) return;

    final participants = <ParticipantInfo>[];

    // Add local participant
    if (_localParticipant != null) {
      participants.add(ParticipantInfo(
        participant: _localParticipant!,
        isLocal: true,
        isHost: true, // Assuming local user is host for now
      ));
    }

    // Add remote participants
    for (final participant in _room!.remoteParticipants.values) {
      participants.add(ParticipantInfo(
        participant: participant,
        isLocal: false,
      ));
    }

    _participants = participants;
  }
}