import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../auth/login_view.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.dark);

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        bool isDark = _themeMode.value == ThemeMode.dark;
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text('Configurações', style: TextStyle(color: Colors.white)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tema Escuro', style: TextStyle(color: Colors.white)),
              Switch(
                value: isDark,
                onChanged: (value) {
                  setState(() {
                    _themeMode.value = value ? ThemeMode.dark : ThemeMode.light;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'perfil':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tela de Perfil em construção...')),
        );
        break;
      case 'cadastrar':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastrar Skin em breve...')),
        );
        break;
      case 'config':
        _showSettingsDialog();
        break;
      case 'logout':
        _logout(context);
        break;
    }
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

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeMode,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;

        return MaterialApp(
          themeMode: themeMode,
          theme: ThemeData.light().copyWith(
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black),
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black, foregroundColor: Colors.white),
          ),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              title: Text('Bem-vindo, ${widget.user.username}'),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: _onMenuSelected,
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'perfil', child: Text('Perfil')),
                    const PopupMenuItem(value: 'cadastrar', child: Text('Cadastrar Skin')),
                    const PopupMenuItem(value: 'config', child: Text('Configurações')),
                    const PopupMenuItem(value: 'logout', child: Text('Logout')),
                  ],
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minhas Skins',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
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
                          color: isDark ? const Color(0xFF121212) : Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(
                              Icons.whatshot,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            title: Text(
                              skin['name']!,
                              style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            ),
                            subtitle: Text(
                              skin['rarity']!,
                              style: TextStyle(color: isDark ? Colors.grey : Colors.black54),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
