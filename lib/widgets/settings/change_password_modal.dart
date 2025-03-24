import 'package:flutter/material.dart';

class ChangePasswordModal extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(String, String) onSave;

  const ChangePasswordModal({
    Key? key,
    required this.onCancel,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Simple validation
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() => _errorMessage = 'All fields are required');
      return;
    }

    if (newPassword.length < 8) {
      setState(() => _errorMessage = 'New password must be at least 8 characters');
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => _errorMessage = 'Passwords don\'t match');
      return;
    }

    // Clear error and call save
    setState(() => _errorMessage = null);
    widget.onSave(currentPassword, newPassword);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onCancel,
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
              child: SingleChildScrollView(
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
                    const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212529),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Current password
                    _buildPasswordField(
                      label: 'Current Password',
                      controller: _currentPasswordController,
                      obscureText: !_showCurrentPassword,
                      toggleVisibility: () => setState(() => _showCurrentPassword = !_showCurrentPassword),
                    ),
                    const SizedBox(height: 16),

                    // New password
                    _buildPasswordField(
                      label: 'New Password',
                      controller: _newPasswordController,
                      obscureText: !_showNewPassword,
                      toggleVisibility: () => setState(() => _showNewPassword = !_showNewPassword),
                    ),
                    const SizedBox(height: 16),

                    // Confirm password
                    _buildPasswordField(
                      label: 'Confirm New Password',
                      controller: _confirmPasswordController,
                      obscureText: !_showConfirmPassword,
                      toggleVisibility: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                    ),

                    // Error message
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFFFF5757),
                            fontSize: 14,
                          ),
                        ),
                      ),

                    // Action buttons
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: TextButton(
                            onPressed: widget.onCancel,
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
                        const SizedBox(width: 16),

                        // Save button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _validateAndSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4361EE),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
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
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6C757D),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFCED4DA),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF212529),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: const Color(0xFF6C757D),
                ),
                onPressed: toggleVisibility,
              ),
            ],
          ),
        ),
      ],
    );
  }
}