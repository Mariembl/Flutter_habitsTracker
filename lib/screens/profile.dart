import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'editProfile.dart'; // Import de la page EditProfile

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Récupération des données utilisateur
      final userData = doc.data() ?? {};

      // Récupération de la sous-collection "habbits"
      final habitsQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('habbits')
          .get();

      final habits = habitsQuerySnapshot.docs;

      // Calcul des statistiques
      int habitsCount = habits.length;
      int streaks = 0;
      int goalsAchieved = 0;

      DateTime? lastDate;

      for (var habit in habits) {
        final progress = habit['progress'] ?? 0;
        final lastUpdated = habit['lastUpdated'] != null
            ? (habit['lastUpdated'] as Timestamp).toDate()
            : null;

        // Incrémenter les goals si le progrès est à 100%
        if (progress >= 100) {
          goalsAchieved++;
        }

        // Calculer les streaks si les dates sont consécutives
        if (lastUpdated != null) {
          if (lastDate == null) {
            streaks++;
          } else if (lastUpdated.difference(lastDate).inDays == 1) {
            streaks++;
          }
          lastDate = lastUpdated;
        }
      }

      // Ajouter les statistiques calculées
      userData['habitsCreated'] = habitsCount;
      userData['streaks'] = streaks;
      userData['goalsAchieved'] = goalsAchieved;

      return userData;
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF8967B3),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error fetching data",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final userData = snapshot.data ?? {};
          final userName = userData['name'] ?? 'User Name';
          final userEmail = userData['email'] ?? 'user@example.com';
          final habitsCreated = userData['habitsCreated'] ?? 0;
          final streaks = userData['streaks'] ?? 0;
          final goalsAchieved = userData['goalsAchieved'] ?? 0;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Avatar utilisateur
                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFFE6D9A2),
                  child: Text(
                    userName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF624E88),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Nom de l'utilisateur
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // Email de l'utilisateur
                Text(
                  userEmail,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),
                // Section statistiques
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCB80AB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Statistics",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatItem(
                            label: "Habits Created",
                            value: "$habitsCreated",
                          ),
                          StatItem(
                            label: "Streaks",
                            value: "$streaks Days",
                          ),
                          StatItem(
                            label: "Goals Achieved",
                            value: "$goalsAchieved",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Boutons pour gérer le profil
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfile(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8967B3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6D9A2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Log Out",
                              style: TextStyle(
                                color: Color(0xFF624E88),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      backgroundColor: const Color(0xFF624E88),
    );
  }
}

// Widget pour afficher un élément statistique
class StatItem extends StatelessWidget {
  final String label;
  final String value;

  const StatItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
