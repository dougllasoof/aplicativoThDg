import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/database_helper.dart';

class ProfileView extends StatefulWidget {
  final User user;
  const ProfileView({super.key, required this.user});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _newPassCtrl = TextEditingController();
  bool _saving = false;

  Future<void> _changePassword() async {
    final newPass = _newPassCtrl.text.trim();
    if (newPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Digite a nova senha')));
      return;
    }

    setState(() => _saving = true);
    await DatabaseHelper.instance.updateUserPassword(widget.user.id!, newPass);
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha atualizada')));
    _newPassCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Conta'), backgroundColor: isDark ? Colors.black : Colors.white),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuário: ${widget.user.username}', style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 18)),
            const SizedBox(height: 8),
            Text('Senha atual: ${widget.user.password}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
            const SizedBox(height: 16),
            const Text('Trocar senha', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _newPassCtrl,
              obscureText: true,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Nova senha',
                labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                filled: true,
                fillColor: const Color(0xFF121212),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _changePassword,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                child: _saving ? const CircularProgressIndicator() : const Text('Atualizar senha'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
