import 'package:flutter/material.dart';
import 'package:grocery_manager/screens/ajouter_editer_produit.dart';
import 'package:grocery_manager/screens/list_categorie.dart';
import 'package:grocery_manager/screens/list_product.dart';
import 'package:grocery_manager/screens/list_unite.dart';

abstract class Routes {
  static const  LISTE_PRODUIT = "/listeProduit";
  static const  SEARCH_PRODUIT = "/searchProduit";
  static const  LISTE_CATEGORIE = "/listeCategorie";
  static const  AJOUTER_EDITER_PRODUIT = "/ajouterEditerProduit";
  static const  LISTE_UNITE = "/listeUnite";

  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case LISTE_PRODUIT:
        return MaterialPageRoute(builder: (context) => ListProduct());
        break;
      // case SEARCH_PRODUIT:
      //   return MaterialPageRoute(builder: (context) => Search());
      //   break;
      case LISTE_CATEGORIE:
        return MaterialPageRoute(builder: (context) => ListCategories());
        break;
      case LISTE_UNITE:
        return MaterialPageRoute(builder: (context) => ListUnite());
        break;
      case AJOUTER_EDITER_PRODUIT:
        return MaterialPageRoute(builder: (context) => AjouterEditerProduit());
        break;
      default:
        var routeArray = settings.name.split('/');
        if (settings.name.contains('$AJOUTER_EDITER_PRODUIT/')) {
          return MaterialPageRoute(
            builder: (context) => AjouterEditerProduit(
              produitId: routeArray[2],
            )
          );
        }
        return MaterialPageRoute(builder: (context) => ListProduct());
    }
  }
}