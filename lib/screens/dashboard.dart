import 'package:flutter/material.dart';
import 'habits.dart'; // Page des habitudes
import 'profile.dart'; // Page du profil
import 'settings.dart'; // Page des paramètres

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xFF624E88),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section utilisateur (nom ou icône)
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFE6D9A2),
              child: Text(
                "N", // Initiale de l'utilisateur (exemple)
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF624E88),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Welcome, User Name!", // Remplacez par le nom dynamique
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            // Boutons de navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bouton "View Habits"
                _buildNavigationButton(
                  context: context,
                  icon: Icons.list,
                  label: "View Habits",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HabitsPage(),
                      ),
                    );
                  },
                ),
                // Bouton "Profile"
                _buildNavigationButton(
                  context: context,
                  icon: Icons.person,
                  label: "Profile",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
                // Bouton "Settings"
                _buildNavigationButton(
                  context: context,
                  icon: Icons.settings,
                  label: "Settings",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF624E88),
    );
  }

  // Méthode pour construire un bouton de navigation
  Widget _buildNavigationButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.27,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF8967B3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
