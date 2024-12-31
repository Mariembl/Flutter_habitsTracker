import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'aboutPage.dart'; // Nouvelle page

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notificationsEnabled = true;
  bool _isDarkTheme = false;

  void _changeTheme(bool? isDark) {
    if (isDark != null) {
      setState(() {
        _isDarkTheme = isDark;
        // Sauvegarde dans Firestore
        FirebaseFirestore.instance
            .collection('settings')
            .doc('theme')
            .set({'dark_mode': isDark});
      });
      print("Theme changed to ${_isDarkTheme ? 'Dark' : 'Light'}");
    }
  }

  void _toggleNotifications(bool? enabled) {
    if (enabled != null) {
      setState(() {
        _notificationsEnabled = enabled;
        // Sauvegarde dans Firestore
        FirebaseFirestore.instance
            .collection('settings')
            .doc('notifications')
            .set({'enabled': enabled});
      });
      print("Notifications ${_notificationsEnabled ? 'Enabled' : 'Disabled'}");
    }
  }

  void _navigateToAbout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutPage()),
    );
  }

  Future<void> _resetProgress(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final habitsCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('habbits');

        final habitsSnapshot = await habitsCollection.get();

        for (var habitDoc in habitsSnapshot.docs) {
          await habitsCollection.doc(habitDoc.id).update({'progress': 0});
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("All habit progress has been reset.")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error resetting progress: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF8967B3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notifications
          SwitchListTile(
            title: const Text(
              "Enable Notifications",
              style: TextStyle(color: Colors.white),
            ),
            value: _notificationsEnabled,
            onChanged: (bool? value) => _toggleNotifications(value),
            activeColor: const Color(0xFFE6D9A2),
          ),
          const Divider(color: Colors.white54),

          // Change Theme
          ListTile(
            leading: const Icon(Icons.color_lens, color: Colors.white),
            title: const Text(
              "Change Theme",
              style: TextStyle(color: Colors.white),
            ),
            trailing: DropdownButton<bool>(
              value: _isDarkTheme,
              dropdownColor: const Color(0xFF624E88),
              underline: Container(),
              items: const [
                DropdownMenuItem(
                  value: false,
                  child: Text("Light Theme", style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: true,
                  child: Text("Dark Theme", style: TextStyle(color: Colors.white)),
                ),
              ],
              onChanged: (bool? value) => _changeTheme(value),
            ),
          ),
          const Divider(color: Colors.white54),

          // About
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: const Text(
              "About",
              style: TextStyle(color: Colors.white),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () => _navigateToAbout(context),
          ),
          const Divider(color: Colors.white54),

          // Reset Progress
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Reset Progress"),
                      content: const Text(
                          "Are you sure you want to reset the progress for all your habits?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Confirm"),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  await _resetProgress(context);
                }
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              label: const Text(
                "Reset Habit Progress",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCB80AB),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5, // Ajout d'une ombre légère pour l'effet 3D
                textStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF624E88),
    );
  }
}
