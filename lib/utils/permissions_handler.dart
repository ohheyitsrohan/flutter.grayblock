import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsHandler {
  // Request camera and microphone permissions
  static Future<bool> requestMediaPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    bool allGranted = true;

    if (statuses[Permission.camera] != PermissionStatus.granted) {
      allGranted = false;
      _showPermissionDialog(
          context,
          'Camera Permission',
          'Camera permission is required to use the video features of this app.'
      );
    }

    if (statuses[Permission.microphone] != PermissionStatus.granted) {
      allGranted = false;
      _showPermissionDialog(
          context,
          'Microphone Permission',
          'Microphone permission is required to use the audio features of this app.'
      );
    }

    return allGranted;
  }

  // Show permission error dialog
  static void _showPermissionDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}