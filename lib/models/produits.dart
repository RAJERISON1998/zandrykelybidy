import 'dart:convert';

import 'package:meta/meta.dart';

class Produit {
  final int id;
  final String idProduit;
  final String nomProduit;
  final int quantiteProduit;
  final double prixDachatProduit;
  final double prixDeVenteProduit;
  final double prixDeGrosProduit;
  final String uniteProduit;
  final String categorieProduit;

  final double pourcentageGrosProduit;
  final double pourcentageDetailsProduit;
  final String uniteAchatProduit;

  Produit({
    @required this.id,
    this.idProduit,
    this.nomProduit,
    this.quantiteProduit,
    this.prixDachatProduit,
    this.prixDeVenteProduit,
    this.prixDeGrosProduit,
    this.uniteProduit,
    this.categorieProduit,
    this.pourcentageGrosProduit,
    this.pourcentageDetailsProduit,
    this.uniteAchatProduit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idProduit': idProduit,
      'nomProduit': nomProduit,
      'quantiteProduit': quantiteProduit,
      'prixDachatProduit': prixDachatProduit,
      'prixDeVenteProduit': prixDeVenteProduit,
      'prixDeGrosProduit': prixDeGrosProduit,
      'uniteProduit': uniteProduit,
      'categorieProduit': categorieProduit,
      'pourcentageGrosProduit': pourcentageGrosProduit,
      'pourcentageDetailsProduit': pourcentageDetailsProduit,
      'uniteAchatProduit': uniteAchatProduit,
    };
  }

  factory Produit.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Produit(
      id: map['id'] ?? 0,
      idProduit: map['idProduit'] ?? '',
      nomProduit: map['nomProduit'] ?? '',
      quantiteProduit: map['quantiteProduit'] ?? 0,
      prixDachatProduit: map['prixDachatProduit'] ?? 0.0,
      prixDeVenteProduit: map['prixDeVenteProduit'] ?? 0.0,
      prixDeGrosProduit: map['prixDeGrosProduit'] ?? 0.0,
      uniteProduit: map['uniteProduit'] ?? '',
      categorieProduit: map['categorieProduit'] ?? '',
      pourcentageGrosProduit: map['pourcentageGrosProduit'] ?? 0.0,
      pourcentageDetailsProduit: map['pourcentageDetailsProduit'] ?? 0.0,
      uniteAchatProduit: map['uniteAchatProduit'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Produit.fromJson(String source) => Produit.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Produit(id: $id, idProduit: $idProduit, nomProduit: $nomProduit, quantiteProduit: $quantiteProduit, prixDachatProduit: $prixDachatProduit, prixDeVenteProduit: $prixDeVenteProduit, prixDeGrosProduit: $prixDeGrosProduit, uniteProduit: $uniteProduit, categorieProduit: $categorieProduit, pourcentageGrosProduit: $pourcentageGrosProduit, pourcentageDetailsProduit: $pourcentageDetailsProduit, uniteAchatProduit: $uniteAchatProduit)';
  }
}
