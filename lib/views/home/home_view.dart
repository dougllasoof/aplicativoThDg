import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/skin.dart';
import '../../services/database_helper.dart';
import '../../services/theme_service.dart';
import 'add_skin_view.dart';
import 'skin_detail_view.dart';
import 'profile_view.dart';
import 'settings_view.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Skin> skins = [];

  @override
  void initState() {
    super.initState();
    _loadSkins();
  }

  Future<void> _loadSkins() async {
    final list = await DatabaseHelper.instance.getSkinsByUser(widget.user.id!);
    setState(() => skins = list);
  }

  void _openAddSkin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddSkinView(user: widget.user)),
    );
    await _loadSkins();
  }

  void _onMenuSelected(String v) {
    if (v == 'account') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProfileView(user: widget.user)),
      ).then((_) => _loadSkins());
    } else if (v == 'settings') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsView()),
      );
    } else if (v == 'logout') {
  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
}

  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.themeMode.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, ${widget.user.username}'),
        backgroundColor: isDark ? Colors.black : Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAddSkin,
            tooltip: 'Adicionar arma/skin',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _onMenuSelected,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'account', child: Text('Conta')),
              PopupMenuItem(value: 'settings', child: Text('Configurações')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          )
        ],
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: skins.isEmpty
            ? Center(
                child: Text(
                  'Nenhuma arma cadastrada.\nToque no + para adicionar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                ),
              )
            : ListView.builder(
                itemCount: skins.length,
                itemBuilder: (context, i) {
                  final s = skins[i];
                  return Card(
                    color: isDark ? const Color(0xFF121212) : Colors.grey[200],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          s.imagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      title: Text(
                        s.weaponName,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        s.skinType,
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddSkinView(
                                  user: widget.user,
                                  editingSkin: s,
                                ),
                              ),
                            );
                            await _loadSkins();
                          } else if (value == 'delete') {
                            await DatabaseHelper.instance.deleteSkin(s.id!);
                            await _loadSkins();
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Editar')),
                          PopupMenuItem(value: 'delete', child: Text('Excluir')),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SkinDetailView(skinId: s.id!),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
