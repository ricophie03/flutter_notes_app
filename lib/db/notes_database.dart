import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_example_2/model/note.dart';

class NoteDatabases {
  static final NoteDatabases instance = NoteDatabases._init();
  static Database? _database;
  NoteDatabases._init();

  // Method untuk mengambil database yang ada atau bikin database baru
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db'); // buat database notes.db
    return _database!;
  }

  // Method untuk mencari lokasi untuk menyimpan database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // lokasi database
    final path = join(dbPath, filePath); // contoh : directory/notes.db

    // version : selalu tambah 1 jika ada perubahan di database
    // onUpgrade : jika ingin mengedit database, misalnya tambah field baru dll
    return await openDatabase(path,
        version: 1, onCreate: _createDB); // buat database di lokasi path
  }

  //Method membuat table dalam database
  //Method ini hanya dijalankan jika database notes.db belum ada di devices.
  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final intType = 'INTEGER NOT NULL';

    // dalam method _createDB, bisa bikin lebih dari 1 table data jika mau sisa copy code dibawah dan ganti nama tablenya.
    //create table sql
    await db.execute('''
      CREATE TABLE $tableNotes ( 
        ${NoteFields.id} $idType, 
        ${NoteFields.isImportant} $boolType,
        ${NoteFields.number} $intType,
        ${NoteFields.title} $textType,
        ${NoteFields.description} $textType,
        ${NoteFields.time} $textType
        )
      ''');
  }

  // menutup koneksi ke database
  Future close() async {
    final db = await instance.database;

    db.close(); // tutup koneksi database
  }

  //menyimpan data ke database
  Future<Note> create(Note note) async {
    final db = await instance.database;

    // insert(nama table, data dalam bentuk map)
    final id = await db.insert(tableNotes, note.toJson());

    return note.copy(id: id);
  }

  //baca 1 data dari database
  Future<Note> readNote(int id) async {
    final db = await instance.database;

    //query : tabel, columns : list field database, where : kata kunci untuk mencari, whereArgs : kunci yang dicari
    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} =  ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(
          maps.first); //maps.first karena hanya 1 data yang ingin diambil
    } else {
      throw Exception('ID $id is not found.');
    }
  }

  //baca semua data dari database
  Future<List<Note>> readAllNote() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.time} ASC';

    // query(table) untuk membaca semua data dalam tabel.
    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  //update data di database
  Future<int> update(Note note) async {
    final db = await instance.database;

    //update (table, data baru dalam json, where : kata kunci untuk mencari data, whereArgs : kata kunci update)
    return db.update(tableNotes, note.toJson(),
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }

  //delete data di database
  Future<int> delete(int id) async {
    final db = await instance.database;

    //delete(tabel, where : kata kunci data yang dihapus, whereArgs : kata kunci)
    return await db
        .delete(tableNotes, where: '${NoteFields.id} = ?', whereArgs: [id]);
  }
}
