import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:tap2025/models/user_model.dart';

class UserDatabase {
  static const NAMEDB = 'USERDB';
  static const VERSIONDB = 1;

  static Database? _database; //Esta variable se encarga de apuntar a la base de datos.
  Future<Database?> get database async{ //PATRON SINGLETON
    //En este metodo se valida que solo exista una instan. Es la variable que apunta la conexion a la base de datos.
    if( _database != null ) return _database;
    //Si marca error puede ser porque aun no se hace la conexion a la base de datos.
    return _database = await initDatabase(); //Intenta generar la conexion.
    //Cuando se pide que se cree un método se hace en la misma clase. Si creas una función se hace fuera de la clase.
    //El método se tiene que instanciar. En una función no se necesita instanciar y solamente se llama con su propio nombre.
  }
  
  Future <Database?> initDatabase() async {
    //El Database? se envuelve en un 
    //Vamos a construir la base de datos. Para eso se necesita ver los datos de los archivos del telefono.
    Directory folder = await getApplicationDocumentsDirectory(); //Con el await saca el paquete del directorio para poder usarlo.
    String path = join(folder.path, NAMEDB); //El join es una librería que ya se tiene pre importada por eso no la tuvimos que agregar.
    return openDatabase(
      path,
      version: VERSIONDB,
      onCreate: (db, version){
        String query = '''CREATE TABLE tblUsers(
          idUser INTEGER PRIMARY KEY,
          userName varchar(50),
          passName varchar(32)
        )
        ''';
        db.execute(query);
      },
    ); 
  }

  Future<int> INSERT(Map<String,dynamic> data) async {
    //El int que se regresa significa que regresa el id que inserto.
    final con = await database; //Esta no es una variable, se llama al get, revisa si existe la conexión sino la crea.
    //Las variables llevan _ al principio.
    return con!.insert('tblUsers', data);
  }

  Future<int> UPDATE(Map<String,dynamic> data) async{
    final con = await database;
    return con!.update('tblUsers', 
    data, where: 'idUser=?', 
    whereArgs: [data['idUser']]
    ); //Cuando lleva un signo de interrogacion son consultas parametrisadas, evitando inyección SQL. Se establece la lista con corchetes.
  }
  Future<int> DELETE(int idUser) async{
    final Database? con = await database;
    return con!.delete('tblUsers',
    where: 'idUser = ?',
    whereArgs: [idUser]
    );
  }
  Future<List<UserModel>> SELECT() async{
    final con = await database;
    final res = await con!.query('tblUsers');
    return res.map((user) => UserModel.fromMap(user)).toList();
  }
}