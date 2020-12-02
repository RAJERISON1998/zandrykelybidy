import 'dart:convert';

class Unite {
  final int id;
  final String idUnite;
  final String nomUnite;
  
  Unite({
    this.id,
    this.idUnite,
    this.nomUnite,
  });

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'idUnite': idUnite,
      'nomUnite': nomUnite,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  factory Unite.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    
    return Unite(
      id: map['id'],
      idUnite: map['idUnite'] ?? '',
      nomUnite: map['nomUnite'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Unite.fromJson(String source) => Unite.fromMap(json.decode(source));

  @override
  String toString() => 'Unite(id: $id, idUnite: $idUnite, nomUnite: $nomUnite)';
}
