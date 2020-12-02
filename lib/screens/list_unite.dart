import 'package:flutter/material.dart';
import 'package:grocery_manager/blocs/unite_bloc.dart';
import 'package:grocery_manager/models/unite.dart';
import 'package:grocery_manager/styles/colors.dart';
import 'package:grocery_manager/styles/text.dart';
import 'package:grocery_manager/widgets/app_button.dart';
import 'package:grocery_manager/widgets/my_autocomplete.dart';
import 'package:provider/provider.dart';
import 'package:grocery_manager/widgets/toast.dart';


class ListUnite extends StatefulWidget {
  @override
  _ListUniteState createState() => _ListUniteState();
}

class _ListUniteState extends State<ListUnite> {
  TextEditingController _controller = TextEditingController();
  // Future<List<Unite>> allUnite ;

  refreshList(UniteBloc uniteBloc) {
    uniteBloc.changeSaved(null);
    uniteBloc.changeId(null);
    uniteBloc.changeIdUnite(null);
    uniteBloc.changeNomUnite("");
    // allUnite = uniteBloc.getAllUnite();
    setState(() {
      _controller.text = "";
    });
  }

  @override
  void initState() {
    var uniteBloc = Provider.of<UniteBloc>(context, listen: false);
    uniteBloc.uniteSaved.listen((saved) {
      if (saved != null && saved == true && context != null) {
        showToastFunction('unite sauvegarder');
        refreshList(uniteBloc);
      }
    });  
    refreshList(uniteBloc);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    var uniteBloc = Provider.of<UniteBloc>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Liste des unites'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              uniteBloc.changeNavigatorPoped(true);
              Navigator.of(context).pop();
            },
          ),
        ),  
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildContainerTop(uniteBloc),
            _buildUniteList(uniteBloc)
          ]
        ),
      ),
    );
  }

  Container _buildContainerTop(UniteBloc uniteBloc) {
    return Container(
      child: Column(
        children: <Widget>[
          _streamBuilderNomUnite(uniteBloc),
          _buildRowbutton(uniteBloc),
        ],
      ),
    );
  }

  Row _buildRowbutton(UniteBloc uniteBloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<String>(
          stream: uniteBloc.idUnite,
          builder: (context, idUniteStream) {
            return StreamBuilder<bool>(
              stream: uniteBloc.isValid,
              builder: (context, isValidStream) {
                return AppButton(
                  buttonText: (idUniteStream.data == null)
                    ? "Ajouter"
                    : "Editer",
                  buttonType: (isValidStream.data == true)
                    ? ButtonType.Green
                    : ButtonType.Disabled,
                  onPressed: () => uniteBloc.saveOrUpdateUnite(),
                );
              }
            );
          }
        ),
        AppButton(
          buttonText: "Annuler",
          buttonType: ButtonType.Red,
          onPressed: () {
            refreshList(uniteBloc);
          },
        ),
      ],
    );
  }

  StreamBuilder<String> _streamBuilderNomUnite(UniteBloc uniteBloc) {
    return StreamBuilder<String>(
      stream: uniteBloc.nomUnite,
      builder: (context, snapshot) {
        return AppAutoCompleteTextField(
          hintText: "Entrer le nom de l'unite",
          errorText: snapshot.error,
          onChanged: uniteBloc.changeNomUnite,
          textController: _controller,
          suggestionCallback: uniteBloc.getSuggestionUnite(_controller.text),
          itemBuilder: (context, suggestion ) {
            return ListTile(
              title: Text(suggestion.nomUnite),
            );
          } ,
          suggestionSelected: (unite) {
            uniteBloc.changeId(unite.id);
            uniteBloc.changeIdUnite(unite.idUnite);
            uniteBloc.changeNomUnite(unite.nomUnite);
            setState(() {
              _controller.text = unite.nomUnite;
            });
          },
        );
      }
    );
  }

  Expanded _buildUniteList(UniteBloc uniteBloc) {
    return Expanded(
      child: SingleChildScrollView(
        child: StreamBuilder<List<Unite>>(
          stream: uniteBloc.getAllUnite(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.length == 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Please add unite',
                  style: TextStyles.body,
                ),
              );
            } 
            return DataTable(
              dataRowHeight: 30,
              columns: [
                DataColumn(
                  label: Text('Nom unite'),
                ),
                DataColumn(
                  label: Text('Delete'),
                ),
              ], 
              rows: snapshot.data
                .map((unite) => DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text(unite.nomUnite),
                      onTap: () {
                        uniteBloc.changeId(unite.id);
                        uniteBloc.changeIdUnite(unite.idUnite);
                        uniteBloc.changeNomUnite(unite.nomUnite);
                        setState(() {
                          _controller.text = unite.nomUnite;
                        });
                      }
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: AppColors.red,  
                        onPressed: () {
                          uniteBloc.deleteUnite(unite.id);
                          refreshList(uniteBloc);
                        },
                      )
                    ),
                  ] 
                ))
                .toList()
            );
          }
        ),
      ),
    );
  }
}