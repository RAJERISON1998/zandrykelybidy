import 'dart:async';

import 'package:grocery_manager/models/produits.dart';
import 'package:grocery_manager/services/database_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class ProduitBloc {
  final _id = BehaviorSubject<int>();
  final _idProduit = BehaviorSubject<String>();
  final _nomProduit = BehaviorSubject<String>();
  final _quantiteProduit = BehaviorSubject<String>();
  final _prixDachatProduit = BehaviorSubject<String>();
  final _prixDeVenteProduit = BehaviorSubject<String>();
  final _prixDeGrosProduit = BehaviorSubject<String>();
  final _uniteProduit = BehaviorSubject<String>();
  final _categorieProduit = BehaviorSubject<String>();
  final _pourcentageGrosProduit = BehaviorSubject<String>();
  final _pourcentageDetailsProduit = BehaviorSubject<String>();
  final _uniteAchatProduit = BehaviorSubject<String>();
  final _errorMessage = BehaviorSubject<String>(); 
  final _produitSaved = BehaviorSubject<bool>();
  final _produitEdited = BehaviorSubject<bool>();
  final _produitElement = BehaviorSubject<Produit>();
  final _isValid = BehaviorSubject<bool>();  
  final _refresh = BehaviorSubject<bool>();

  final db = DatabaseHelper.instance;
  var uuid = Uuid();

  dispose() {
    _id.close();
    _idProduit.close();
    _nomProduit.close();
    _quantiteProduit.close();
    _prixDachatProduit.close();
    _prixDeVenteProduit.close();
    _prixDeGrosProduit.close();
    _uniteProduit.close();
    _categorieProduit.close();
    _pourcentageGrosProduit.close();
    _pourcentageDetailsProduit.close();
    _uniteAchatProduit.close();
    _errorMessage.close();
    _produitSaved.close();
    _produitEdited.close();
    _produitElement.close();
    _isValid.close();
    _refresh.close();
  } 

  //********************************************************************************** 
  //**********************************************************************************
  //Getter
  //********************************************************************************** 
  //**********************************************************************************

  Stream<int> get id => _id.stream;
  Stream<String> get idProduit => _idProduit.stream;
  Stream<String> get nomProduit => _nomProduit.stream
    .transform(validerNomProduit);
  Stream<int> get quantiteProduit => _quantiteProduit.stream
    .transform(validerEntier);
  Stream<double> get prixDachatProduit => _prixDachatProduit.stream
    .transform(validerDouble);
  Stream<double> get prixDeVenteProduit => _prixDeVenteProduit.stream
    .transform(validerDouble);
  Stream<double> get prixDeGrosProduit => _prixDeGrosProduit.stream
    .transform(validerDouble);
  Stream<String> get uniteProduit => _uniteProduit.stream
    .transform(validerSimpleString);
  Stream<String> get categorieProduit => _categorieProduit.stream
    .transform(validerSimpleString);
  Stream<double> get pourcentageGrosProduit => _pourcentageGrosProduit.stream
    .transform(validerDouble);
  Stream<double> get pourcentageDetailsProduit => _pourcentageDetailsProduit.stream
    .transform(validerDouble);
  Stream<String> get uniteAchatProduit => _uniteAchatProduit.stream
    .transform(validerSimpleString);
  Stream<bool> get produitEdited => _produitEdited.stream;
  Stream<bool> get isValid => CombineLatestStream.combine9(
    nomProduit,
    quantiteProduit,
    prixDachatProduit,
    pourcentageDetailsProduit,
    pourcentageGrosProduit,
    prixDeVenteProduit,
    prixDeGrosProduit,
    uniteProduit,
    uniteAchatProduit,
    (a,b,c,d,e,f,g,h,i) => true);
  Stream<bool> get refresh => _refresh.stream;
  Stream<String> get errorMessage => _errorMessage.stream;
  Stream<bool> get produitSaved => _produitSaved.stream;
  Future<void> deleteProduit(int id) => db.deteteProduit(id);
  Future<List<Produit>> getAllProduitFuture() => db.getAllProduits();
  Stream<List<Produit>> getAllProduitStream() => db.getAllProduits().asStream();
  Future<List<Produit>> getSuggestionProduit(String query) =>
    db.getSuggestionProduit(query);
  Future<Produit> getProduitById(String id) => db.getProduitById(id);
  Stream<Produit> getProduitElement() => _produitElement.stream;
  Future<int> getNombreProduit() => db.getNombreProduit();

  //********************************************************************************** 
  //**********************************************************************************
  // getter value
  //********************************************************************************** 
  //**********************************************************************************

  String getNomProduitValue() => _nomProduit.value; 
  String getQuantiteProduitValue() => _quantiteProduit.value; 
  String getPrixDachatProduitValue() => _prixDachatProduit.value; 
  String getPrixDeVenteProduitValue() => _prixDeVenteProduit.value; 
  String getPrixDeGrosProduitValue() => _prixDeGrosProduit.value; 
  String getPourcentageGrosProduitValue() => _pourcentageGrosProduit.value; 
  String getPourcentageDetailsProduitValue() => _pourcentageDetailsProduit.value; 
  
  String getValueGros() => _prixDeGrosProduit.value;
  String getValueDetails() => _prixDeVenteProduit.value;
  double getValuePrixAchat() => double.tryParse(_prixDachatProduit.value);
  double getValueCoefficientGros() => double.tryParse(_pourcentageGrosProduit.value);
  double getValueCoefficeintDetails() => double.tryParse(_pourcentageDetailsProduit.value);
  int getValueQuantite() => int.tryParse(_quantiteProduit.value);
  
  //********************************************************************************** 
  //**********************************************************************************
  //Setter
  //********************************************************************************** 
  //**********************************************************************************

  Function(int) get changeId => _id.sink.add;
  Function(String) get changeIdProduit => _idProduit.sink.add;
  Function(String) get changeNomProduit => _nomProduit.sink.add;
  Function(String) get changeQuantiteProduit => _quantiteProduit.sink.add;
  Function(String) get changePrixDachatProduit => _prixDachatProduit.sink.add;
  Function(String) get changePrixDeVenteProduit => _prixDeVenteProduit.sink.add;
  Function(String) get changePrixDeGrosProduit => _prixDeGrosProduit.sink.add;
  Function(String) get changeUniteProduit => _uniteProduit.sink.add;
  Function(String) get changeCategorieProduit => _categorieProduit.sink.add;
  Function(bool) get changeProduitSaved => _produitSaved.sink.add;
  Function(bool) get changeRefresh => _refresh.sink.add;
  Function(bool) get changeProduitEdited => _produitEdited.sink.add;
  Function(String) get changePourcentageGrosProduit => _pourcentageGrosProduit.sink.add;
  Function(String) get changePourcentageDetailsProduit => _pourcentageDetailsProduit.sink.add;
  Function(String) get changeUniteAchatProduit => _uniteAchatProduit.sink.add;
  Function(Produit) get changeProduitElement => _produitElement.sink.add;

  //********************************************************************************** 
  //**********************************************************************************
  //Validators
  //********************************************************************************** 
  //**********************************************************************************

  final validerNomProduit = StreamTransformer<String, String>
    .fromHandlers(handleData: (nomProduit, sink) {
      if (nomProduit != null) {
        if (nomProduit.length >= 3 && nomProduit.length <= 35) {
          sink.add(nomProduit);
        } else {
          if (nomProduit.length < 3) {
            sink.addError('3 Character Minimum');
          } else {
            sink.addError('35 Character Maximum');
          }
        }
      }
  });

  final validerSimpleString = StreamTransformer<String, String>
    .fromHandlers(handleData: (nomProduit, sink) {
      if (nomProduit.length >= 2) {
          sink.add(nomProduit);
        } else {
          if (nomProduit.length < 2) {
            sink.addError('3 Character Minimum');
          } else {
            sink.addError('35 Character Maximum');
          }
        }
  });

  final validerEntier = StreamTransformer<String, int>
  .fromHandlers( handleData: (entierData, sink) {
    if (entierData != null) {
      try {
        sink.add(int.parse(entierData));
      } catch (error) {
        sink.addError('Doit etre un nombre entier');
      }
    }
  });

  final validerDouble = StreamTransformer<String, double>
  .fromHandlers( handleData: (doubleData, sink) {
    if (doubleData != null) {
      try {
        sink.add(double.parse(doubleData));
      } catch (error) {
        sink.addError('Doit etre un nombre');
      }
    }
  });

  calculerPrix() {
    double valuePrixDeGros;
    double valuePrixDetails;
    double valuePrixAchat = getValuePrixAchat();
    double coefficientGros = getValueCoefficientGros();
    double coefficeintDetails = getValueCoefficeintDetails();
    int quantite = getValueQuantite();
    valuePrixDeGros = valuePrixAchat * coefficientGros;
    valuePrixDetails = valuePrixDeGros * coefficeintDetails / quantite;
    _prixDeGrosProduit.sink.add(valuePrixDeGros.toString());
    _prixDeVenteProduit.sink.add(valuePrixDetails.toString());
  }

  printAllStreamValue() {
    print("************");
    print("_id");
    print(_id.value);
    print("_idProduit");
    print(_idProduit.value);
    print("_nomProduit");
    print(_nomProduit.value);
    print("_quantiteProduit");
    print(_quantiteProduit.value);
    print("_prixDachatProduit");
    print(_prixDachatProduit.value);
    print("_prixDeVenteProduit");
    print(_prixDeVenteProduit.value);
    print("_prixDeGrosProduit");
    print(_prixDeGrosProduit.value);
    print("_uniteProduit");
    print(_uniteProduit.value);
    print("_categorieProduit");
    print(_categorieProduit.value);
    print("_pourcentageGrosProduit");
    print(_pourcentageGrosProduit.value);
    print("_pourcentageDetailsProduit");
    print(_pourcentageDetailsProduit.value);
    print("_uniteAchatProduit");
    print(_uniteAchatProduit.value);
  }

  //********************************************************************************** 
  //**********************************************************************************
  //Produit state
  //********************************************************************************** 
  //**********************************************************************************

  refreshAll() {
    _id.sink.add(null);
    _idProduit.sink.add(null);
    _nomProduit.sink.add(null);
    _quantiteProduit.sink.add(null);
    _prixDachatProduit.sink.add(null);
    _prixDeVenteProduit.sink.add(null);
    _prixDeGrosProduit.sink.add(null);
    _uniteProduit.sink.add(null);
    _categorieProduit.sink.add(null);
    _produitSaved.sink.add(null);
    _produitEdited.sink.add(null);
    _pourcentageGrosProduit.sink.add(null);
    _pourcentageDetailsProduit.sink.add(null);
    _uniteAchatProduit.sink.add(null);
    _produitElement.sink.add(null);
  }

  initCalculator() {
    _quantiteProduit.sink.add("1");
    _prixDachatProduit.sink.add("1");
    _prixDeVenteProduit.sink.add("0");
    _prixDeGrosProduit.sink.add("0");
    _pourcentageGrosProduit.sink.add("1.1");
    _pourcentageDetailsProduit.sink.add("1.1");
  }

  loadProduit(Produit produit) {
    _id.sink.add(produit.id);
    _idProduit.sink.add(produit.idProduit);
    _nomProduit.sink.add(produit.nomProduit);
    _quantiteProduit.sink.add(produit.quantiteProduit.toString());
    _prixDachatProduit.sink.add(produit.prixDachatProduit.toString());
    _prixDeVenteProduit.sink.add(produit.prixDeVenteProduit.toString());
    _prixDeGrosProduit.sink.add(produit.prixDeGrosProduit.toString());
    _uniteProduit.sink.add(produit.uniteProduit);
    _categorieProduit.sink.add(produit.categorieProduit);
    _pourcentageGrosProduit.sink.add(produit.pourcentageGrosProduit.toString());
    _pourcentageDetailsProduit.sink.add(produit.pourcentageDetailsProduit.toString());
    _uniteAchatProduit.sink.add(produit.uniteAchatProduit);
    _produitElement.sink.add(produit);
  }

  //********************************************************************************** 
  //**********************************************************************************
  //Functions
  //********************************************************************************** 
  //**********************************************************************************
  
  Future<void> saveOrUpdateProduit() async {
    var produit = Produit(
      id: (_id.value == null) 
        ? null
        : _id.value,
      idProduit: (_idProduit.value == null)
        ? uuid.v4()
        : _idProduit.value,
      nomProduit: _nomProduit.value,
      quantiteProduit: int.tryParse(_quantiteProduit.value),
      prixDachatProduit: double.tryParse(double.tryParse(_prixDachatProduit.value).toStringAsFixed(2)),
      prixDeGrosProduit: double.tryParse(double.tryParse(_prixDeGrosProduit.value).toStringAsFixed(2)),
      prixDeVenteProduit: double.tryParse(double.tryParse(_prixDeVenteProduit.value).toStringAsFixed(2)),
      pourcentageDetailsProduit: double.tryParse(double.tryParse(_pourcentageDetailsProduit.value).toStringAsFixed(2)),
      pourcentageGrosProduit: double.tryParse(double.tryParse(_pourcentageGrosProduit.value).toStringAsFixed(2)),
      uniteProduit:( _uniteProduit.value == null)
        ? ""
        : _uniteProduit.value,
      categorieProduit: (_categorieProduit.value == null)
        ? ''
        : _categorieProduit.value,
      uniteAchatProduit: (_uniteAchatProduit == null)
        ? ""
        : _uniteAchatProduit.value,
    );

    // if (_id.value != null) {
    //   await db.deteteProduit(_id.value);
    // }

    if (_id.value == null) {
      return db
        .insererProduit(produit)
        .then((value) {
          _produitSaved.sink.add(true);
          // refreshAll();
        })
        .catchError((error) {
          _produitSaved.sink.add(false);
          print(error);
          _errorMessage.sink.add(error);
        });
    } else {
      return db
        .updateProduit(produit)
        .then((value) {
          _produitEdited.sink.add(true);
          // refreshAll();
        })
        .catchError((error) {
          _produitEdited.sink.add(false);
          print(error);
          _errorMessage.sink.add(error);
        });
    }

    
  }
}