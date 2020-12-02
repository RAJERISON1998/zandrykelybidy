import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:grocery_manager/styles/buttons.dart';
import 'package:grocery_manager/widgets/app_button.dart';

class MyExpansionTileCard extends StatefulWidget {
  final String nomProduit;
  final String quantiteProduit;
  final String prixDachatProduit;
  final String prixDeVenteProduit;
  final String prixDeGrosProduit;
  final String uniteDeDetails;
  final String categorieProduit;
  final String uniteDeGros;
  final String coefficentGros;
  final String coefficientDetails;
  final int id;
  final Function() delete;
  final Function() editer;

  MyExpansionTileCard({
    this.nomProduit = "",
    this.quantiteProduit = "",
    this.prixDachatProduit = "",
    this.prixDeVenteProduit = "",
    this.prixDeGrosProduit = "",
    this.categorieProduit = "",
    this.id,
    this.delete,
    this.editer, 
    this.uniteDeDetails, 
    this.uniteDeGros, 
    this.coefficentGros, 
    this.coefficientDetails
  });

  @override
  _MyExpansionTileCardState createState() => _MyExpansionTileCardState();
}

class _MyExpansionTileCardState extends State<MyExpansionTileCard> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTileCard(
      title: Text(widget.nomProduit),
      leading: CircleAvatar(
        child: (widget.nomProduit.length != 0) 
          ? Text(widget.nomProduit[0])
          : '*'
      ),
      children: <Widget>[
        Divider(
          color: Colors.black,
        ),
        DataTable(
          dataRowHeight: ButtonStyles.height,
          columns: [
            DataColumn(
              label: Text('Type'),
            ),
            DataColumn(
              label: Text('Details'),
            ),
          ], 
          rows: <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Nom')),
                DataCell(Text(widget.nomProduit)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Quantite ')),
                DataCell(Text(widget.quantiteProduit+" " +widget.uniteDeDetails+" / "+widget.uniteDeGros)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text("Prix d'achat")),
                DataCell(Text(widget.prixDachatProduit+" / "+widget.uniteDeGros)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Prix de vente')),
                DataCell(Text(widget.prixDeVenteProduit+" / "+widget.uniteDeDetails)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Prix de gros')),
                DataCell(Text(widget.prixDeGrosProduit+" / "+widget.uniteDeGros)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Categorie')),
                DataCell(Text(widget.categorieProduit)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Coefficient prix de gros')),
                DataCell(Text(widget.coefficentGros)),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Coefficient prix de details')),
                DataCell(Text(widget.coefficientDetails)),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppButton(
              buttonText: 'Editer',
              buttonType: ButtonType.Green,
              height: ButtonStyles.height,
              onPressed: widget.editer,
            ),
            AppButton(
              buttonText: 'Effacer',
              buttonType: ButtonType.Red,
              height: ButtonStyles.height,
              onPressed: widget.delete,
            ),
          ],
        )
      ],
    );
  }
}