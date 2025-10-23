import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../auth/login_view.dart';

class HomePage extends StatelessWidget {
  final User user;
  const HomePage({super.key, required this.user});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fakeSkins = [
      {'name': 'AK-47 | Redline', 'rarity': 'Classified'},
      {'name': 'AWP | Dragon Lore', 'rarity': 'Covert'},
      {'name': 'M4A1-S | Hyper Beast', 'rarity': 'Classified'},
      {'name': 'Desert Eagle | Blaze', 'rarity': 'Covert'},
      {'name': 'USP-S | Kill Confirmed', 'rarity': 'Covert'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, ${user.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Minhas Skins',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: fakeSkins.length,
                itemBuilder: (context, index) {
                  final skin = fakeSkins[index];
                  return Card(
                    color: const Color(0xFF121212),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.whatshot,
                        color: Colors.white70,
                      ),
                      title: Text(
                        skin['name']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        skin['rarity']!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
