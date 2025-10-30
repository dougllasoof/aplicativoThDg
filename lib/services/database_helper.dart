import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../models/skin.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cs_skins_app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE skins (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        weaponName TEXT NOT NULL,
        skinType TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        userId INTEGER NOT NULL
      )
    ''');
  }

  // ---- User methods ----
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String username, String password) async {
    final db = await database;
    final result = await db.query('users',
        where: 'username = ? AND password = ?', whereArgs: [username, password]);
    if (result.isNotEmpty) return User.fromMap(result.first);
    return null;
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return User.fromMap(result.first);
    return null;
  }

  Future<bool> usernameExists(String username) async {
    final db = await database;
    final result = await db.query('users', where: 'username = ?', whereArgs: [username]);
    return result.isNotEmpty;
  }

  Future<int> updateUserPassword(int userId, String newPassword) async {
    final db = await database;
    return await db.update('users', {'password': newPassword},
        where: 'id = ?', whereArgs: [userId]);
  }

  // ---- Skin methods ----
  Future<int> insertSkin(Skin skin) async {
    final db = await database;
    return await db.insert('skins', skin.toMap());
  }

  Future<List<Skin>> getSkinsByUser(int userId) async {
    final db = await database;
    final maps = await db.query('skins', where: 'userId = ?', whereArgs: [userId]);
    return maps.map((m) => Skin.fromMap(m)).toList();
  }

  Future<Skin?> getSkinById(int id) async {
    final db = await database;
    final maps = await db.query('skins', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Skin.fromMap(maps.first);
    return null;
  }

  Future<int> updateSkin(Skin skin) async {
    final db = await database;
    return await db.update('skins', skin.toMap(),
        where: 'id = ?', whereArgs: [skin.id]);
  }

  Future<int> deleteSkin(int id) async {
    final db = await database;
    return await db.delete('skins', where: 'id = ?', whereArgs: [id]);
  }
}
