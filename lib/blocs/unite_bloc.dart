import 'dart:async';

import 'package:grocery_manager/models/unite.dart';
import 'package:grocery_manager/services/database_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class UniteBloc {
  final _id = BehaviorSubject<int>();
  final _idUnite = BehaviorSubject<String>();
  final _nomUnite = BehaviorSubject<String>(); 
  final _errorMessage = BehaviorSubject<String>(); 
  final _uniteSaved = BehaviorSubject<bool>();
  final _isValid = BehaviorSubject<bool>();
  final _validateOne = BehaviorSubject<bool>();
  final _navigatorPoped = BehaviorSubject<bool>();

  final db = DatabaseHelper.instance;
  var uuid = Uuid();
  

  dispose() {
    _id.close();
    _idUnite.close();
    _nomUnite.close();
    _uniteSaved.close();
    _errorMessage.close();
    _isValid.close();
    _validateOne.close();
    _navigatorPoped.close();
  }

  //get
  Stream<int> get id => _id.stream;
  Stream<String> get idUnite => _idUnite.stream;
  Stream<String> get nomUnite => _nomUnite.stream
    .transform(validerProduitNom);
  Stream<bool> get uniteSaved => _uniteSaved.stream;
  Stream<bool> get isAlwaysValid => _nomUnite.stream
    .transform(validateOne);
  Stream<bool> get isValid => CombineLatestStream.combine2(
    nomUnite, isAlwaysValid, ( a, b) => true
  );
  Stream<bool> get navigatorIsPoped => _navigatorPoped.stream;
  Stream<String> get errorMessage => _errorMessage.stream;
  Stream<void> deleteUnite(int id) => db.deteteUnite(id).asStream();
  Stream<List<Unite>> getAllUnite() => db.getAllUnite().asStream();
  Future<List<Unite>> getAllUniteFuture() => db.getAllUnite(); 
  Future<List<Unite>> getSuggestionUnite(String query) => 
    db.getSuggestionUnite(query);

  Future<int> getNombreUnite() => db.getNombreUnite();
  // DatabaseHelper getDatabase() => db;

  //Set 
  Function(String) get changeNomUnite => _nomUnite.sink.add;
  Function(String) get changeIdUnite => _idUnite.sink.add;
  Function(int) get changeId => _id.sink.add;
  Function(bool) get changeSaved => _uniteSaved.sink.add;
  Function(bool) get changeIsValid => _isValid.sink.add;
  Function(bool) get changeNavigatorPoped => _navigatorPoped.sink.add;

  //Validators
  final validerProduitNom = StreamTransformer<String, String>
    .fromHandlers(handleData: (produitNom, sink) {
      if (produitNom != null) {
        if (produitNom.length >= 3 && produitNom.length <= 20) {
          sink.add(produitNom.trim());
        } else {
          if (produitNom.length < 3) {
            sink.addError('3 Character Minimum');
          } else {
            sink.addError('20 Character Maximum');
          }
        }
      }
  });

  final validateOne = StreamTransformer<String, bool>
    .fromHandlers(handleData: (produitNom, sink) {
      if (produitNom.length >= 3 && produitNom.length <= 20) {
          sink.add(true);
        } else {
          if (produitNom.length < 3) {
            sink.addError(false);
          } else {
            sink.addError(false);
          }
        }
  });


  //Functions
  Future<void> saveOrUpdateUnite() async {
    var unite = Unite(
      id: (_id.value == null) 
        ? null
        : _id.value,
      idUnite: (_idUnite.value == null)
        ? uuid.v4()
        : _idUnite.value,
      nomUnite: _nomUnite.value
    );

    return db
      .insererUnite(unite)
      .then((value) {
        _uniteSaved.sink.add(true);
        // _nomUnite.sink.add("");
      })
      .catchError((error) {
        _uniteSaved.sink.add(false);
        _errorMessage.sink.add(error);
      });
  }
}