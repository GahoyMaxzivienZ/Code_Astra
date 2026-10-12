import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSigningOut = false;

  static const _violet = Color(0xFF3C3489);
  static const _bg = Color(0xFFEDE9FB);

  Future<void> _handleSignOut() async {
    setState(() => _isSigningOut = true);
    try {
      await AuthService.signOut();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSigningOut = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hindi nakapag-sign out: $e')),
      );
    }
    // Kapag successful ang sign out, awtomatikong bumabalik sa LoginScreen
    // dahil "nakikinig" ang AuthGate sa main.dart sa authStateChanges —
    // wala nang kailangan pang gawin dito.
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _violet,
        foregroundColor: Colors.white,
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.white,
                backgroundImage:
                    user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                child: user?.photoURL == null
                    ? Icon(Icons.person, size: 44, color: _violet.withOpacity(0.4))
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                user?.displayName ?? 'Walang pangalan',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _violet,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: TextStyle(fontSize: 13, color: _violet.withOpacity(0.6)),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _violet.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(Icons.school_outlined, 'CvSU Student/Faculty'),
                    const Divider(height: 20),
                    _infoRow(Icons.verified_outlined, 'Verified via Google'),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _isSigningOut ? null : _handleSignOut,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isSigningOut
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout),
                  label: Text(_isSigningOut ? 'Nagsi-sign out...' : 'Sign Out'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _violet.withOpacity(0.6)),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
