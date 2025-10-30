import 'package:flutter/material.dart';
import '../../services/theme_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.themeMode.value == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações'), backgroundColor: isDark ? Colors.black : Colors.white),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Tema escuro'),
              trailing: Switch(
                value: isDark,
                onChanged: (v) {
                  ThemeService.instance.toggle();
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
