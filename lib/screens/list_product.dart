import 'package:flutter/material.dart';
import 'package:grocery_manager/blocs/produit_bloc.dart';
import 'package:grocery_manager/styles/text_field.dart';
import 'package:grocery_manager/widgets/My_expansion_tile.dart';
import 'package:grocery_manager/widgets/right_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class ListProduct extends StatefulWidget {
  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> { 
  TextEditingController _controllerProduit = TextEditingController();

  @override
  void initState() {

    var produitBloc = Provider.of<ProduitBloc>(context, listen: false);

    produitBloc.refresh.listen((refresh) {
      if (refresh != null && refresh == true && context != null) {
        produitBloc.refreshAll();
        // produitBloc.changeProduitSaved(null);
      }
    });

    setState(() {
      _controllerProduit.text = "";
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var produitBloc = Provider.of<ProduitBloc>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des produits'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed('/ajouterEditerProduit'),
          )
        ],
      ),
      drawer: RightDrawer(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.of(context).pushNamed('/ajouterEditerProduit'),
      //   child: Icon(Icons.add),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomPadding: true,

      // bottomNavigationBar: BottomAppBar(
      //   clipBehavior: Clip.antiAlias,
      //   shape: CircularNotchedRectangle(),
      //   notchMargin: 5,
      //   child: Container(
      //     height: 50,
      //     color: Colors.blue,
      //   ),
      // ), 
      body: _buildColumnListProduit(produitBloc),   
    );
  }

  Column _buildColumnListProduit(ProduitBloc produitBloc) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: TextFieldStyles.textBoxHorizontal - 10, 
            right: TextFieldStyles.textBoxVertical,
            left:  TextFieldStyles.textBoxVertical 
          ),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              style:TextFieldStyles.text,
              decoration: TextFieldStyles.autocompleteDecoration(
                "Entrer le nom du produit a recherher"
              ),
              cursorColor: TextFieldStyles.cursorColor,
              textAlign: TextFieldStyles.textAlign,
              controller: _controllerProduit,
            ),
            hideOnEmpty: true,
            hideOnLoading: true,
            hideSuggestionsOnKeyboardHide:false,
            keepSuggestionsOnLoading: false,
            suggestionsCallback: (pattern) async {
              return produitBloc.getSuggestionProduit(_controllerProduit.text);
            },
            itemBuilder: (context, suggestion) {
              return MyExpansionTileCard(
                nomProduit: suggestion.nomProduit.toString(),
                categorieProduit: suggestion.categorieProduit,
                prixDachatProduit: suggestion.prixDachatProduit.toString(),
                prixDeGrosProduit: suggestion.prixDeGrosProduit.toString(),
                prixDeVenteProduit: suggestion.prixDeVenteProduit.toString(),
                quantiteProduit: suggestion.quantiteProduit.toString(),
                uniteDeDetails: suggestion.uniteProduit,
                uniteDeGros: suggestion.uniteAchatProduit,
                coefficentGros: suggestion.pourcentageGrosProduit.toString(),
                coefficientDetails: suggestion.pourcentageDetailsProduit.toString(),
                delete: () {
                  produitBloc.deleteProduit(suggestion.id);
                },
                editer: () => {
                  Navigator.of(context)
                    .pushNamed("/ajouterEditerProduit/${suggestion.idProduit}")
                }
              );
            }, 
            onSuggestionSelected: (_) {},
          ),
        ),
      ],
    );
  }
}


