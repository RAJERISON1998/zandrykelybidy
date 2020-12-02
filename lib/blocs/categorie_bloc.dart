import 'dart:async';

import 'package:grocery_manager/models/categories.dart';
import 'package:grocery_manager/services/database_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class CategorieBloc {
  final _id = BehaviorSubject<int>();
  final _idCategorie = BehaviorSubject<String>();
  final _nomCategorie = BehaviorSubject<String>(); 
  final _errorMessage = BehaviorSubject<String>(); 
  final _categorieSaved = BehaviorSubject<bool>();
  final _isValid = BehaviorSubject<bool>();
  final _validateOne = BehaviorSubject<bool>();
  final _navigatorPoped = BehaviorSubject<bool>();


  final db = DatabaseHelper.instance;
  var uuid = Uuid();
  

  dispose() {
    _id.close();
    _idCategorie.close();
    _nomCategorie.close();
    _categorieSaved.close();
    _errorMessage.close();
    _isValid.close();
    _validateOne.close();
    _navigatorPoped.close();
  }
  //********************************************************************************** 
  //**********************************************************************************
  //get
  //********************************************************************************** 
  //**********************************************************************************

  Stream<int> get id => _id.stream;
  Stream<String> get idCategorie => _idCategorie.stream;
  Stream<String> get nomCategorie => _nomCategorie.stream
    .transform(validerNomCategorie);
  Stream<bool> get categorieSaved => _categorieSaved.stream;
  Stream<bool> get isAlwaysValid => _nomCategorie.stream
    .transform(validateOne);
  Stream<bool> get isValid => CombineLatestStream.combine2(
    nomCategorie, isAlwaysValid, ( a, b) => true
  );
  Stream<bool> get navigatorIsPoped => _navigatorPoped.stream;
  Stream<String> get errorMessage => _errorMessage.stream;
  Future<void> deleteCategorie(int id) => db.deteteCategorie(id);
  Stream<List<Categorie>> getAllCategorie() => db.getAllCategories().asStream(); 
  Future<List<Categorie>> getAllCategorieFuture() => db.getAllCategories(); 
  Future<List<Categorie>> getSuggestionCategorie(String query) => 
    db.getSuggestionCategorie(query);
  Future<int> getNombreCategorie() => db.getNombreCategorie();

  //********************************************************************************** 
  //**********************************************************************************
  //Set 
  //********************************************************************************** 
  //**********************************************************************************

  Function(String) get changeNomCategorie => _nomCategorie.sink.add;
  Function(String) get changeIdCategorie => _idCategorie.sink.add;
  Function(int) get changeId => _id.sink.add;
  Function(bool) get changeSaved => _categorieSaved.sink.add;
  Function(bool) get changeIsValid => _isValid.sink.add;
  Function(bool) get changeNavigatorPoped => _navigatorPoped.sink.add;


  //********************************************************************************** 
  //**********************************************************************************
  //Validators
  //********************************************************************************** 
  //**********************************************************************************

  final validerNomCategorie = StreamTransformer<String, String>
    .fromHandlers(handleData: (nomCategorie, sink) {
      if (nomCategorie != null) {
        if (nomCategorie.length >= 3 && nomCategorie.length <= 20) {
          sink.add(nomCategorie.trim());
        } else {
          if (nomCategorie.length < 3) {
            sink.addError('3 Character Minimum');
          } else {
            sink.addError('20 Character Maximum');
          }
        }
      }
  });

  final validateOne = StreamTransformer<String, bool>
    .fromHandlers(handleData: (nomCategorie, sink) {
      if (nomCategorie.length >= 3 && nomCategorie.length <= 20) {
          sink.add(true);
        } else {
          if (nomCategorie.length < 3) {
            sink.addError(false);
          } else {
            sink.addError(false);
          }
        }
  });

  //********************************************************************************** 
  //**********************************************************************************
  //Functions
  //********************************************************************************** 
  //**********************************************************************************

  Future<void> saveOrUpdateCategorie() async {
    var categorie = Categorie(
      id: (_id.value == null) 
        ? null
        : _id.value,
      idCategorie: (_idCategorie.value == null)
        ? uuid.v4()
        : _idCategorie.value,
      nomCategorie: _nomCategorie.value
    );

    return db
      .insererCategorie(categorie)
      .then((value) {
        _categorieSaved.sink.add(true);
        // _nomUnite.sink.add("");
      })
      .catchError((error) {
        _categorieSaved.sink.add(false);
        print(error);
        _errorMessage.sink.add(error);
      });
  }
}