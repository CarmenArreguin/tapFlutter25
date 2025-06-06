import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:tap2025/models/user_model.dart';

class UserDatabase {
  static const String _nameBD = 'user_db.db';
  static const int _versionBD = 1;
  static const String _tableUser = 'tblUsers';

  static Database? _database; //Esta variable se encarga de apuntar a la base de datos.
  Future<Database?> get database async{ //PATRON SINGLETON
    //En este metodo se valida que solo exista una instan. Es la variable que apunta la conexion a la base de datos.
    if( _database != null ) return _database;
    //Si marca error puede ser porque aun no se hace la conexion a la base de datos.
    return _database = await _initDatabase(); //Intenta generar la conexion.
    //Cuando se pide que se cree un método se hace en la misma clase. Si creas una función se hace fuera de la clase.
    //El método se tiene que instanciar. En una función no se necesita instanciar y solamente se llama con su propio nombre.
  }
  
  Future <Database?> _initDatabase() async {
    //El Database? se envuelve en un 
    //Vamos a construir la base de datos. Para eso se necesita ver los datos de los archivos del telefono.
    Directory folder = await getApplicationDocumentsDirectory(); //Con el await saca el paquete del directorio para poder usarlo.
    String path = join(folder.path, _nameBD); //El join es una librería que ya se tiene pre importada por eso no la tuvimos que agregar.
    return openDatabase(
      path,
      version: _versionBD,
      onCreate: (db, version){
        db.execute('''
          CREATE TABLE $_tableUser (
            idUser INTEGER PRIMARY KEY,
            userName TEXT,
            passName TEXT
          )
        ''');
      },
    ); 
  }

  Future<int> insert(Map<String,dynamic> data) async {
    try {
      final db = await database;
      return await db!.insert(_tableUser, data);
    } catch (e) {
      print('Error insertando usuario: $e');
      return -1;
    }
  }

  Future<int> update(Map<String,dynamic> data) async{
    try {
      final db = await database;
      return await db!.update(
        _tableUser,
        data,
        where: 'idUser = ?',
        whereArgs: [data['idUser']],
      );
    } catch (e) {
      print('Error actualizando usuario: $e');
      return -1;
    }
  }

  Future<int> delete(int idUser) async {
    try {
      final db = await database;
      return await db!.delete(
        _tableUser,
        where: 'idUser = ?',
        whereArgs: [idUser],
      );
    } catch (e) {
      print('Error eliminando usuario: $e');
      return -1;
    }
  }

  Future<List<UserModel>> selectAll() async{
    try {
      final db = await database;
      final List<Map<String, dynamic>> res = await db!.query(_tableUser);
      return res.map((e) => UserModel.fromMap(e)).toList();
    } catch (e) {
      print('Error obteniendo usuarios: $e');
      return [];
    }
  }
}