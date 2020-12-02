import 'package:flutter/material.dart';
import 'package:grocery_manager/blocs/categorie_bloc.dart';
import 'package:grocery_manager/blocs/produit_bloc.dart';
import 'package:grocery_manager/blocs/unite_bloc.dart';
import 'package:grocery_manager/routes.dart';
import 'package:grocery_manager/screens/list_product.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

final uniteBloc = UniteBloc();
final categorieBloc = CategorieBloc();
final produitBloc = ProduitBloc();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => uniteBloc),
        Provider(create: (context) => categorieBloc),
        Provider(create: (context) => produitBloc),
      ],
      child: MaterialApp(
        title: 'Grocery manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.blue[200],
          // accentColor: Colors.blueAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: Routes.materialRoutes,
        home: ListProduct(),
      ),
    );
  }

  Widget loadingScreen() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
