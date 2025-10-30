class Skin {
  final int? id;
  final String weaponName; // nome da arma
  final String skinType;   // tipo da skin
  final String imagePath;  // caminho da imagem (assets/...)
  final int userId;

  Skin({
    this.id,
    required this.weaponName,
    required this.skinType,
    required this.imagePath,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weaponName': weaponName,
      'skinType': skinType,
      'imagePath': imagePath,
      'userId': userId,
    };
  }

  factory Skin.fromMap(Map<String, dynamic> map) {
    return Skin(
      id: map['id'] as int?,
      weaponName: map['weaponName'] as String,
      skinType: map['skinType'] as String,
      imagePath: map['imagePath'] as String,
      userId: map['userId'] as int,
    );
  }
}
