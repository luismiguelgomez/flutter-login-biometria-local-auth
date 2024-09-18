import 'package:sqflite/sqflite.dart';
import '../model/contact.dart';

class ContactProvider {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table Contact ( 
  id integer primary key autoincrement, 
  name text not null,
  phone text not null,
  email text not null
  )
''');
    });
  }

  Future<Contact> insert(Contact ctct) async {
    ctct.id = await db.insert('Contact', ctct.toMap());
    return ctct;
  }

  Future<Contact?> getContact(int id) async {
    List<Map> maps = await db.query("Contact",
        columns: ['id', 'name', 'phone', 'email'],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Contact.fromMap(maps.first.cast());
    }
    return null;
  }

  Future<List?> getAllContacts() async {
    List<Map> maps = await db.query("Contact",
        columns: ['id', 'name', 'phone', 'email']);
    if (maps.isNotEmpty) {
      return maps.toList();
    }
    return null;
  }


  Future<int> delete(int id) async {
    return await db.delete("Contact", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Contact ctct) async {
    return await db
        .update("Contact", ctct.toMap(), where: 'id = ?', whereArgs: [ctct.id]);
  }

  Future close() async => db.close();
}
