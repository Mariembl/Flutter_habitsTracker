import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: const Color(0xFF8967B3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "About Our App",
                style: TextStyle(
                  color: Color(0xFFE6D9A2),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "This application is designed to help you build and maintain healthy habits "
                    "that enhance your daily life. Track your progress, stay motivated, and reach your goals with ease.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                "Features",
                style: TextStyle(
                  color: Color(0xFFE6D9A2),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "- Create and manage habits.\n"
                    "- Track your daily progress.\n"
                    "- Visualize your progress with graphs.\n"
                    "- Receive notifications and reminders.\n"
                    "- Sync across devices.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                "Our Team",
                style: TextStyle(
                  color: Color(0xFFE6D9A2),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "We are a team of passionate developers dedicated to creating tools that help people "
                    "achieve their personal and professional goals. We believe in the power of small habits to drive big changes.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                "Contact Us",
                style: TextStyle(
                  color: Color(0xFFE6D9A2),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Email: meriem@noussair.com\n"
                    "Phone: +212 661-626264\n"
                    "Website: www.habittrackerapp.com",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                "Privacy Policy",
                style: TextStyle(
                  color: Color(0xFFE6D9A2),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "We value your privacy. Your data is securely stored and will never be shared with third parties "
                    "without your consent.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCB80AB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                ),
                child: const Text(
                  "Go Back",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF624E88),
    );
  }
}
