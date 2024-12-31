import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_habit_form.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  final List<Map<String, dynamic>> _habits = [];
  String? userNameInitial;

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchHabits();
  }

  Future<void> fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userNameInitial = userDoc.data()?['name']?.substring(0, 1)?.toUpperCase();
      });
    }
  }

  Future<void> fetchHabits() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("Aucun utilisateur connecté.");
      return;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('habbits')
          .get();

      setState(() {
        _habits.clear();
        for (var doc in querySnapshot.docs) {
          _habits.add({
            'id': doc.id,
            'nom': doc['nom'],
            'progress': doc['progress'],
            'lastUpdated': doc['lastUpdated'] != null
                ? (doc['lastUpdated'] as Timestamp).toDate()
                : null,
          });
        }
      });
    } catch (e) {
      print("Erreur lors de la récupération des habitudes : $e");
    }
  }

  Future<void> _incrementProgress(String habitId, int index) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("Aucun utilisateur connecté.");
      return;
    }

    try {
      final habitRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('habbits')
          .doc(habitId);

      final updatedProgress = (_habits[index]['progress'] as int) + 10;

      await habitRef.update({
        'progress': updatedProgress,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      setState(() {
        _habits[index]['progress'] = updatedProgress;
      });
    } catch (e) {
      print("Erreur lors de la mise à jour de la progression : $e");
    }
  }

  Future<void> _deleteHabit(String habitId, int index) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("Aucun utilisateur connecté.");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('habbits')
          .doc(habitId)
          .delete();

      setState(() {
        _habits.removeAt(index);
      });
    } catch (e) {
      print("Erreur lors de la suppression de l'habitude : $e");
    }
  }

  void _navigateToAddHabit() async {
    final newHabit = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitForm()),
    );
    if (newHabit != null) {
      _addHabit(newHabit);
    }
  }

  Future<void> _addHabit(String habit) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("Aucun utilisateur connecté.");
      return;
    }

    try {
      final newHabitRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('habbits')
          .doc();

      await newHabitRef.set({
        'nom': habit,
        'progress': 0,
        'created_at': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      fetchHabits();
    } catch (e) {
      print("Erreur lors de l'ajout de l'habitude : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF624E88),
      appBar: AppBar(
        title: Row(
          children: [
            if (userNameInitial != null)
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE6D9A2),
                child: Text(
                  userNameInitial!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF624E88),
                  ),
                ),
              ),
            const SizedBox(width: 10),
            const Text("My Habits"),
          ],
        ),
        backgroundColor: const Color(0xFF8967B3),
      ),
      body: _habits.isEmpty
          ? const Center(
        child: Text(
          "No habits added yet!",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          final habit = _habits[index];
          final progressPercentage = (habit['progress'] / 100).clamp(0, 1);

          return Card(
            color: const Color(0xFFCB80AB),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit['nom'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6D9A2).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        height: 20,
                        width: progressPercentage *
                            MediaQuery.of(context).size.width *
                            0.8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6D9A2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${habit['progress']} / 100 completed",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            _incrementProgress(habit['id'], index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8967B3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Add Progress",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () => _deleteHabit(habit['id'], index),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddHabit,
        backgroundColor: const Color(0xFFCB80AB),
        child: const Icon(Icons.add),
      ),
    );
  }
}
