import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../screens/video_room_screen.dart';
import '../widgets/room/search_bar_widget.dart';
import '../widgets/room/room_grid_widget.dart';
import '../widgets/room/empty_state_widget.dart';
import '../themes/app_colors.dart'; // Import AppColors

class RoomScreen extends StatefulWidget {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  String searchQuery = '';
  List<Room> filteredRooms = [];

  // Initialize with mock data
  late List<Room> rooms;

  @override
  void initState() {
    super.initState();
    rooms = Room.getMockRooms();
    _filterRooms();
  }

  // Filter rooms based on search query
  void _filterRooms() {
    List<Room> result = [...rooms];

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      result = result.where((room) =>
      room.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          room.tags.any((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()))
      ).toList();
    }

    setState(() {
      filteredRooms = result;
    });
  }

  // Join a room
  void _joinRoom(String roomId) {
    // Find the room details
    final room = Room.getMockRooms().firstWhere((room) => room.id == roomId);

    // Navigate to the video room screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoRoomScreen(
          roomName: room.name,
          roomId: room.id,
        ),
      ),
    );
  }

  // Update search query
  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
    _filterRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context), // Use theme background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Study Rooms',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text(context), // Use theme text color
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              SearchBarWidget(
                searchQuery: searchQuery,
                onSearchChanged: _updateSearchQuery,
              ),

              const SizedBox(height: 10),

              // Room Grid or Empty State
              Expanded(
                child: filteredRooms.isEmpty
                    ? const EmptyStateWidget()
                    : RoomGridWidget(
                  rooms: filteredRooms,
                  onJoinRoom: _joinRoom,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}