// Dart (Flutter)
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'home_shell_page.dart';
class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _firstNameController = TextEditingController(text: 'Alex');
  final _lastNameController = TextEditingController(text: 'Morgan');
  final _emailController = TextEditingController(text: 'alex@example.com');
  bool? _hasLicence = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20, top: 16),
            child: Text(
              '02 / 04',
              style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            // Dark Community Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1C221B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ROAD BOND COMMUNITY',
                    style: TextStyle(color: AppColors.primaryLime, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Your next crew is closer\nthan you think.',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, height: 1.25),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.people_alt_outlined, color: Colors.white70, size: 14),
                      SizedBox(width: 4),
                      Text('2.4k riders', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      SizedBox(width: 14),
                      Icon(Icons.location_on_outlined, color: Colors.white70, size: 14),
                      SizedBox(width: 4),
                      Text('180+ routes', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'CREATE YOUR RIDER PROFILE',
              style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
            ),
            const SizedBox(height: 6),
            const Text(
              "Let's get to know you.",
              style: TextStyle(color: AppColors.textDark, fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Just the essentials. You can finish your profile later.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 20),

            // Name inputs
            Row(
              children: [
                Expanded(child: _buildTextField('First name', _firstNameController)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('Last name', _lastNameController)),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField('Email address', _emailController),
            const SizedBox(height: 18),

            // Licence Radio
            const Text(
              'Do you have a motorcycle licence?',
              style: TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildOptionTile(
                    title: 'Yes, I do',
                    isSelected: _hasLicence == true,
                    onTap: () => setState(() => _hasLicence = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOptionTile(
                    title: 'Not yet',
                    isSelected: _hasLicence == false,
                    onTap: () => setState(() => _hasLicence = false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Continue CTA
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeShellPage()),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.textDark),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile({required String title, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF5D8) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.textDark : AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.textDark,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textDark)),
          ],
        ),
      ),
    );
  }
}