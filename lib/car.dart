import 'dbhelper.dart';

class Car {
  int? id;
  String? nom;
  int? estrelles;
  int? capacitat;

  Car(this.id, this.nom, this.estrelles, this.capacitat);

  Car.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nom = map['nom'];
    estrelles = map['estrelles'];
    capacitat = map['capacitat'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnNom: nom,
      DatabaseHelper.columnEstrelles: estrelles,
      DatabaseHelper.columnCapacitat: capacitat,
    };
  }
}