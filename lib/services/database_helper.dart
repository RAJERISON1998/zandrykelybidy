import 'dart:async';
import 'dart:io';

import 'package:grocery_manager/models/categories.dart';
import 'package:grocery_manager/models/produits.dart';
import 'package:grocery_manager/models/unite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static const ID = 'id';
  static const TABLE_CATEGORIE = 'tableCategorie';
  static const TABLE_PRODUIT = 'tableProduit';
  static const TABLE_UNITE = 'tableUnite';
  static const ID_PRODUIT = 'idProduit';
  static const NOM_PRODUIT = 'nomProduit';
  static const CATEGORIE_PRODUIT = 'categorieProduit';
  static const QUANTITE_PRODUIT = 'quantiteProduit';
  static const PRIX_DACHAT_PRODUIT = 'prixDachatProduit';
  static const PRIX_DE_VENTE_PRODUIT = 'prixDeVenteProduit';
  static const PRIX_DE_GROS_PRODUIT = 'prixDeGrosProduit';
  static const UNITE_PRODUIT = 'uniteProduit';
  
  static const POURCENTAGE_GROS_PRODUIT = "pourcentageGrosProduit ";
  static const POURCENTAGE_DETAILS_PRODUIT = "pourcentageDetailsProduit ";
  static const UNITE_ACHAT_PRODUIT = "uniteAchatProduit ";

  static const ID_CATEGORIE = 'idCategorie';
  static const NOM_CATEGORIE = 'nomCategorie';
  
  static const ID_UNITE = 'idUnite';
  static const NOM_UNITE = 'nomUnite';
  
  static const _databaseName = 'groceryManager.db';
  static const _databaseVersion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  var uuid = Uuid();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreateDB
    );
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE $TABLE_PRODUIT (
          $ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $ID_PRODUIT STRING NOT NULL UNIQUE,
          $NOM_PRODUIT STRING UNIQUE ,
          $PRIX_DACHAT_PRODUIT REAL,
          $PRIX_DE_VENTE_PRODUIT REAL,
          $PRIX_DE_GROS_PRODUIT REAL,
          $QUANTITE_PRODUIT INTEGER,
          $CATEGORIE_PRODUIT STRING,
          $UNITE_PRODUIT STRING,
          $POURCENTAGE_GROS_PRODUIT REAL,
          $POURCENTAGE_DETAILS_PRODUIT REAL,
          $UNITE_ACHAT_PRODUIT STRING
        );
      '''
    );  

    await db.execute(
      '''
        CREATE TABLE $TABLE_CATEGORIE (
          $ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $ID_CATEGORIE STRING NOT NULL UNIQUE,
          $NOM_CATEGORIE STRING NOT NULL UNIQUE
        );
      '''
    );

    await db.execute(
      '''
        CREATE TABLE $TABLE_UNITE (
          $ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $ID_UNITE STRING NOT NULL UNIQUE,
          $NOM_UNITE STRING NOT NULL UNIQUE
        );
      '''
    );  
  }

  //********************************************************************************** 
  //**********************************************************************************
  //Query for produit
  //********************************************************************************** 
  //**********************************************************************************
  
  Future<int> insererProduit(Produit produit) async {
    Database db = await database;
    return await db.insert(
      TABLE_PRODUIT,
      produit.toMap(),
      conflictAlgorithm:ConflictAlgorithm.replace
    );
  }

  Future<int> updateProduit(Produit produit) async {
    Database db = await database;
    return await db.update(
      TABLE_PRODUIT,
      produit.toMap(),
      where: '$ID = ?',
      whereArgs: [produit.id]
    );
  }
  
  Future<int> deteteProduit(int id) async {
    Database db = await database;
    return await db.delete(
      TABLE_PRODUIT,
      where: '$ID = ?',
      whereArgs: [id]
    );
  }

  Future<List<Produit>> getAllProduits() async {
    Database db = await database;
    List<Map> produit = await db.query(
      TABLE_PRODUIT,
      orderBy: "$NOM_PRODUIT ASC"
    );
    return produit.length  == 0
      ? []
      : produit.map((x) => Produit.fromMap(x)).toList();
  } 

  Future<Produit> getProduitById(String id) async {
    Database db = await database;
    var result = await db.query(
      TABLE_PRODUIT,
      where: "$ID_PRODUIT = ?",
      whereArgs: [id]
    );
    return result.isNotEmpty
      ? Produit.fromMap(result.first)
      : null;
  } 

  Future<List<Produit>> getSuggestionProduit(String query) async {
    Database db = await database;
    List<Map> produit = await db.rawQuery("""
      SELECT * FROM $TABLE_PRODUIT 
      WHERE $NOM_PRODUIT
      LIKE '%$query%'
      ORDER BY $NOM_PRODUIT ASC
    """);
    return produit.length  == 0
      ? []
      : produit.map((x) => Produit.fromMap(x)).toList();
  }

  Future<int> getNombreProduit() async {
    Database db = await database;
    int nombre = Sqflite.firstIntValue(await db.rawQuery(
      """
        SELECT COUNT(*) 
        FROM $TABLE_PRODUIT
      """
    ));
    return nombre;
  }
  //********************************************************************************** 
  //**********************************************************************************
    // Query for Categorie
  //********************************************************************************** 
  //**********************************************************************************

  Future<int> insererCategorie(Categorie categorie) async {
    Database db = await database;
    return await db.insert(
      TABLE_CATEGORIE,
      categorie.toMap(),
      conflictAlgorithm:ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCategorie(Categorie categorie) async {
    Database db = await database;
    return await db.update(
      TABLE_CATEGORIE,
      categorie.toMap(),
      where: '$ID = ?',
      whereArgs: [categorie.id]
    );
  }
  
  Future<int> deteteCategorie(int id) async {
    Database db = await database;
    return await db.delete(
      TABLE_CATEGORIE,
      where: '$ID = ?',
      whereArgs: [id]
    );
  }

  Future<List<Categorie>> getAllCategories() async {
    Database db = await database;
    List<Map> categorie = await db.query(TABLE_CATEGORIE);
    return categorie.length  == 0
      ? []
      : categorie.map((x) => Categorie.fromMap(x)).toList();
  }

  Future<List<Categorie>> getSuggestionCategorie(String query) async {
    Database db = await database;
    List<Map> categorie = await db.rawQuery("""
      SELECT * FROM $TABLE_CATEGORIE 
      WHERE $NOM_CATEGORIE 
      LIKE '%$query%'
      ORDER BY $NOM_CATEGORIE ASC
    """);
    print(categorie.length);
    return categorie.length  == 0
      ? []
      : categorie.map((x) => Categorie.fromMap(x)).toList();
  } 

  Future<int> getNombreCategorie() async {
    Database db = await database;
    int nombre = Sqflite.firstIntValue(await db.rawQuery(
      """
        SELECT COUNT(*) 
        FROM $TABLE_CATEGORIE
      """
    ));
    return nombre;
  }

  //*********************************************************************************
  //*********************************************************************************
  
  //Query for unite
  //********************************************************************************** 
  //**********************************************************************************

  Future<int> insererUnite(Unite unite) async {
    Database db = await database;
    return await db.insert(
      TABLE_UNITE,
      unite.toMap(),
      conflictAlgorithm:ConflictAlgorithm.replace
    );
  }

  Future<int> updateUnite(Unite unite) async {
    Database db = await database;
    return await db.update(
      TABLE_UNITE,
      unite.toMap(),
      where: '$ID = ?',
      whereArgs: [unite.id]
    );
  }
  
  Future<int> deteteUnite(int id) async {
    Database db = await database;
    return await db.delete(
      TABLE_UNITE,
      where: '$ID = ?',
      whereArgs: [id]
    );
  }

  Future<List<Unite>> getAllUnite() async {
    Database db = await database;
    List<Map> unite = await db.query(TABLE_UNITE);
    return unite.length  == 0
      ? []
      : unite.map((x) => Unite.fromMap(x)).toList();
  } 

  Future<List<Map<String, dynamic>>> getNomUnite() async {
    Database db = await database;
    List<Map> unite = await db.query(
      TABLE_UNITE,
    );
    return unite;
  } 

  Future<List<Unite>> getSuggestionUnite(String query) async {
    Database db = await database;
    List<Map> unite = await db.rawQuery("""
      SELECT * FROM $TABLE_UNITE 
      WHERE $NOM_UNITE 
      LIKE '%$query%'
    """);
    return unite.length  == 0
      ? []
      : unite.map((x) => Unite.fromMap(x)).toList();
  }

  Future<int> getNombreUnite() async {
    Database db = await database;
    int nombre = Sqflite.firstIntValue(await db.rawQuery(
      """
        SELECT COUNT(*) 
        FROM $TABLE_UNITE
      """
    ));
    return nombre;
  }

  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}