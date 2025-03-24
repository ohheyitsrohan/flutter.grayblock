import 'package:flutter/material.dart';
import '../../models/room_model.dart';
import '../../themes/app_colors.dart'; // Import AppColors

class RoomCardWidget extends StatelessWidget {
  final Room room;
  final Function(String) onJoinRoom;
  final double cardWidth;

  const RoomCardWidget({
    Key? key,
    required this.room,
    required this.onJoinRoom,
    required this.cardWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.card(context), // Use theme color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Room Name
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              room.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.text(context), // Use theme color
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Online Users
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.secondary, // Use theme color
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${room.online} online',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary(context), // Use theme color
                ),
              ),
            ],
          ),

          // Join Button
          SizedBox(
            width: cardWidth * 0.8,
            child: ElevatedButton(
              onPressed: room.active ? () => onJoinRoom(room.id) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: room.active
                    ? AppColors.primary // Use theme color
                    : AppColors.inactiveControl(context), // Use theme color
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(
                room.active ? 'Join' : 'Inactive',
                style: TextStyle(
                  color: room.active
                      ? Colors.white
                      : AppColors.textSecondary(context), // Use theme color
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}