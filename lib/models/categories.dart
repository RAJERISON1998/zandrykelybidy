import 'dart:convert';

class Categorie {
  final int id;
  final String idCategorie;
  final String nomCategorie;
  
  Categorie({
  this.id,
  this.idCategorie,
    this.nomCategorie,
  });

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'idCategorie': idCategorie,
      'nomCategorie': nomCategorie,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  factory Categorie.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Categorie(
      id: map['id'],
      idCategorie: map['idCategorie'] ?? '',
      nomCategorie: map['nomCategorie'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Categorie.fromJson(String source) => Categorie.fromMap(json.decode(source));

  @override
  String toString() => 'Categorie(id: $id, idCategorie: $idCategorie, nomCategorie: $nomCategorie)';
}
