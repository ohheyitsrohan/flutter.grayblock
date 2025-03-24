import 'package:flutter/material.dart';
import '../../models/room_model.dart';
import 'room_card_widget.dart';

class RoomGridWidget extends StatelessWidget {
  final List<Room> rooms;
  final Function(String) onJoinRoom;

  const RoomGridWidget({
    Key? key,
    required this.rooms,
    required this.onJoinRoom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate card width (2 cards per row with spacing)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = (screenWidth - 50) / 2; // Accounting for padding

    return GridView.builder(
      padding: const EdgeInsets.only(top: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.15, // Width to height ratio
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return RoomCardWidget(
          room: room,
          onJoinRoom: onJoinRoom,
          cardWidth: cardWidth,
        );
      },
    );
  }
}