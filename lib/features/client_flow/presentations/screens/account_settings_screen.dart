import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {
  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController phoneCtrl;

  final _formKey = GlobalKey<FormState>();
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();

    final user = context.read<UserProvider>().user;

    nameCtrl = TextEditingController(text: user?.name ?? '');
    emailCtrl = TextEditingController(text: user?.email ?? '');
    phoneCtrl = TextEditingController(
      text: "${user?.countryCode ?? ''} ${user?.phoneNumber ?? ''}",
    );
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isUpdating = true);
    try {
      await context.read<UserProvider>().updateUserName(nameCtrl.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    } finally {
      if (mounted) setState(() => isUpdating = false);
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({bool readOnly = false}) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InputDecoration(
      filled: readOnly,
      fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  Widget _fieldHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Account Settings',
        showLogo: false,
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16),

            // 🔹 Full Name (editable)
            _fieldHeader("Full Name"),
            TextFormField(
              controller: nameCtrl,
              decoration: _inputDecoration(),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Name required' : null,
            ),

            const SizedBox(height: 20),

            // 🔹 Email (read-only)
            _fieldHeader("Email"),
            TextFormField(
              controller: emailCtrl,
              readOnly: true,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
              decoration: _inputDecoration(readOnly: true),
            ),

            const SizedBox(height: 20),

            // 🔹 Phone Number (read-only)
            _fieldHeader("Phone Number"),
            TextFormField(
              controller: phoneCtrl,
              readOnly: true,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
              decoration: _inputDecoration(readOnly: true),
            ),

            const SizedBox(height: 32),

            // 🔹 Save Button
            ElevatedButton.icon(
              icon: isUpdating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(isUpdating ? 'Saving...' : 'Save Changes'),
              onPressed: isUpdating ? null : _updateProfile,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
