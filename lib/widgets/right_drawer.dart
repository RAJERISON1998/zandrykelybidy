import 'package:flutter/material.dart';
import 'package:grocery_manager/main.dart';
import 'package:grocery_manager/routes.dart';
import 'package:grocery_manager/widgets/my_list_tile.dart';

class RightDrawer extends StatefulWidget {
  @override
  _RightDrawerState createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Icon(
              Icons.face,
              color: Colors.blue,
            ),
          ),
          FutureBuilder<int>(
            future: produitBloc.getNombreProduit(),
            builder: (context, snapshot) {
              return MyListTyle(
                title: 'Ajouter un produit',
                leading: snapshot.data.toString(),
                action: () => Navigator.of(context).pushNamed(Routes.AJOUTER_EDITER_PRODUIT),
              );
            }
          ),
          FutureBuilder<int>(
            future: categorieBloc.getNombreCategorie(),
            builder: (context, snapshot) {
              return MyListTyle(
                title: 'Liste categories',
                leading: snapshot.data.toString(),
                action: () => Navigator.of(context).pushNamed(Routes.LISTE_CATEGORIE),
              );
            }
          ),
          FutureBuilder<int>(
            future: uniteBloc.getNombreUnite(),
            builder: (context, snapshot) {
              return MyListTyle(
                title: 'Liste unite',
                leading: snapshot.data.toString(),
                action: () => Navigator.of(context).pushNamed(Routes.LISTE_UNITE),
              );
            }
          )
        ],
      ),
    );
  }
}