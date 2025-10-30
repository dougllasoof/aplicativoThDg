import 'package:flutter/material.dart';
import '../../models/skin.dart';
import '../../services/database_helper.dart';

class SkinDetailView extends StatefulWidget {
  final int skinId;
  const SkinDetailView({super.key, required this.skinId});

  @override
  State<SkinDetailView> createState() => _SkinDetailViewState();
}

class _SkinDetailViewState extends State<SkinDetailView> {
  Skin? skin;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await DatabaseHelper.instance.getSkinById(widget.skinId);
    setState(() {
      skin = s;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Skin'), backgroundColor: isDark ? Colors.black : Colors.white),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : skin == null
              ? const Center(child: Text('Skin não encontrada'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(skin!.weaponName, style: TextStyle(fontSize: 22, color: isDark ? Colors.white : Colors.black)),
                      const SizedBox(height: 8),
                      Text(skin!.skinType, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                      const SizedBox(height: 20),
                      Expanded(child: Image.asset(skin!.imagePath, fit: BoxFit.contain)),
                    ],
                  ),
                ),
    );
  }
}
