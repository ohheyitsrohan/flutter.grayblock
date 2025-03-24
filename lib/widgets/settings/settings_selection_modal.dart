import 'package:flutter/material.dart';

class SettingsSelectionModal extends StatelessWidget {
  final String title;
  final List<String> options;
  final String currentValue;
  final Function(String) onSelect;
  final VoidCallback onCancel;
  final String Function(String)? getDisplayName;

  const SettingsSelectionModal({
    Key? key,
    required this.title,
    required this.options,
    required this.currentValue,
    required this.onSelect,
    required this.onCancel,
    this.getDisplayName,
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Modal handle
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9ECEF),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Modal title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212529),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Options list
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: options.map((option) {
                          final bool isSelected = option == currentValue;
                          final String displayName = getDisplayName != null
                              ? getDisplayName!(option)
                              : option;

                          return GestureDetector(
                            onTap: () => onSelect(option),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFEEF2FF) : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    displayName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected ? const Color(0xFF4361EE) : const Color(0xFF495057),
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check,
                                      color: Color(0xFF4361EE),
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Cancel button
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: onCancel,
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF8F9FA),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color(0xFFCED4DA),
                            width: 1,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF495057),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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