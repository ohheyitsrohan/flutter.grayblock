import 'package:flutter/material.dart';
import '../../themes/app_colors.dart'; // Fixed import path

class GoalSettingModal extends StatelessWidget {
  final String tempGoal;
  final Function(String) onTempGoalChanged;
  final VoidCallback onCancel;
  final Function(int) onSave;

  const GoalSettingModal({
    Key? key,
    required this.tempGoal,
    required this.onTempGoalChanged,
    required this.onCancel,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCancel,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent tap through
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.card(context), // Use theme color
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.modalHandle(context), // Use theme color
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Set Weekly Goal',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context), // Use theme color
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'How many hours do you want to study this week?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary(context), // Use theme color
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.border(context), // Use theme color
                                width: 1,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                            fillColor: AppColors.surface(context), // Use theme color
                            filled: true,
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.text(context), // Use theme color
                          ),
                          controller: TextEditingController(text: tempGoal),
                          onChanged: onTempGoalChanged,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'hours',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.text(context), // Use theme color
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: onCancel,
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.background(context), // Use theme color
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: AppColors.border(context), // Use theme color
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.text(context), // Use theme color
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final int newGoal = int.tryParse(tempGoal) ?? 30;
                            onSave(newGoal);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary, // Use theme color
                            elevation: 4,
                            shadowColor: AppColors.primary.withOpacity(0.3),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}