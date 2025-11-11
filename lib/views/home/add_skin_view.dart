import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/skin.dart';
import '../../services/database_helper.dart';

class AddSkinView extends StatefulWidget {
  final User user;
  final Skin? editingSkin; // se for fornecida, estamos editando

  const AddSkinView({super.key, required this.user, this.editingSkin});

  @override
  State<AddSkinView> createState() => _AddSkinViewState();
}

class _AddSkinViewState extends State<AddSkinView> {
  final _weaponCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  String selectedImage = 'assets/ak_redline.png';

  final List<String> imageOptions = [
    'assets/images/ak.png',
    'assets/images/awp.png',
    'assets/images/m4a1s.png',
    'assets/images/usp.png',
    'assets/images/deagle.png',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editingSkin != null) {
      final s = widget.editingSkin!;
      _weaponCtrl.text = s.weaponName;
      _typeCtrl.text = s.skinType;
      selectedImage = s.imagePath;
    }
  }

  Future<void> _save() async {
    final weapon = _weaponCtrl.text.trim();
    final type = _typeCtrl.text.trim();

    if (weapon.isEmpty || type.isEmpty || selectedImage.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    final db = DatabaseHelper.instance;

    if (widget.editingSkin != null) {
      final s = Skin(
        id: widget.editingSkin!.id,
        weaponName: weapon,
        skinType: type,
        imagePath: selectedImage,
        userId: widget.user.id!,
      );
      await db.updateSkin(s);
    } else {
      final s = Skin(
        weaponName: weapon,
        skinType: type,
        imagePath: selectedImage,
        userId: widget.user.id!,
      );
      await db.insertSkin(s);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _weaponCtrl.dispose();
    _typeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editingSkin != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Skin' : 'Cadastrar Skin'),
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _weaponCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nome da arma',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF121212),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _typeCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Tipo da skin',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF121212),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Escolha uma imagem',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageOptions.length,
                  itemBuilder: (context, index) {
                    final path = imageOptions[index];
                    final selected = path == selectedImage;
                    return GestureDetector(
                      onTap: () => setState(() => selectedImage = path),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: selected ? const EdgeInsets.all(4) : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          border: selected ? Border.all(color: Colors.blue, width: 2) : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          path,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(isEditing ? 'Salvar alterações' : 'Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
