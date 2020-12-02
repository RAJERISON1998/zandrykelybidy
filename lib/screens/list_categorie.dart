import 'package:flutter/material.dart';
import 'package:grocery_manager/blocs/categorie_bloc.dart';
import 'package:grocery_manager/models/categories.dart';
import 'package:grocery_manager/styles/colors.dart';
import 'package:grocery_manager/styles/text.dart';
import 'package:grocery_manager/widgets/app_button.dart';
import 'package:grocery_manager/widgets/my_autocomplete.dart';
import 'package:provider/provider.dart';
import 'package:grocery_manager/widgets/toast.dart';


class ListCategories extends StatefulWidget {
  @override
  _ListCategoriesState createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  TextEditingController _controller = TextEditingController();
  // Future<List<Categorie>> allCategorie ;

  refreshList(CategorieBloc categorieBloc) {
    categorieBloc.changeSaved(null);
    categorieBloc.changeId(null);
    categorieBloc.changeIdCategorie(null);
    categorieBloc.changeNomCategorie("");
    // allCategorie = categorieBloc.getAllCategorie();
    setState(() {
      _controller.text = "";
    });
  }

  @override
  void initState() {
    var categorieBloc = Provider.of<CategorieBloc>(context, listen: false);
    categorieBloc.categorieSaved.listen((saved) {
      if (saved != null && saved == true && context != null) {
        showToastFunction("Categorie saved");
        refreshList(categorieBloc);
      }
    });   
    refreshList(categorieBloc);
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    var categoriBloc = Provider.of<CategorieBloc>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Liste des categories'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              categoriBloc.changeNavigatorPoped(true);
              Navigator.of(context).pop();
            },
          ),
        ),  
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildContainerTop(categoriBloc),
            _buildCatogorieList(categoriBloc),
          ]
        ),
      ),
    );
  }
  Container _buildContainerTop(CategorieBloc categorieBloc) {
    return Container(
      child: Column(
        children: <Widget>[
          _streamBuilderNomCategorie(categorieBloc),
          _buildRowButton(categorieBloc),
        ],
      ),
    );
  }

  Row _buildRowButton(CategorieBloc categorieBloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<String>(
          stream: categorieBloc.idCategorie,
          builder: (context, idCategorieStream) {
            return StreamBuilder<bool>(
              stream: categorieBloc.isValid,
              builder: (context, isValidStream) {
                return AppButton(
                  buttonText: (idCategorieStream.data == null)
                    ? "Ajouter"
                    : "Editer",
                  buttonType: (isValidStream.data == true)
                    ? ButtonType.Green
                    : ButtonType.Disabled,
                  onPressed: () => categorieBloc.saveOrUpdateCategorie(),
                );
              }
            );
          }
        ),
        AppButton(
          buttonText: "Annuler",
          buttonType: ButtonType.Red,
          onPressed: () {
            refreshList(categorieBloc);
          },
        ),
      ],
    );
  }

  StreamBuilder<String> _streamBuilderNomCategorie(CategorieBloc categorieBloc) {
    return StreamBuilder<String>(
      stream: categorieBloc.nomCategorie,
      builder: (context, snapshot) {
        return AppAutoCompleteTextField(
          hintText: 'Entrer le nom du categorie',
          errorText: snapshot.error,
          onChanged: categorieBloc.changeNomCategorie,
          textController: _controller,
          suggestionCallback: categorieBloc.getSuggestionCategorie(_controller.text),
          itemBuilder: (context, suggestion ) {
            return ListTile(
              title: Text(suggestion.nomCategorie),
            );
          } ,
          suggestionSelected: (categorie) {
            categorieBloc.changeId(categorie.id);
            categorieBloc.changeIdCategorie(categorie.idCategorie);
            categorieBloc.changeNomCategorie(categorie.nomCategorie);
            setState(() {
              _controller.text = categorie.nomCategorie;
            });
          },
        );
      }
    );
  }

  Expanded _buildCatogorieList(CategorieBloc categorieBloc) {
    return Expanded(
      child: SingleChildScrollView(
        child: StreamBuilder<List<Categorie>>(
          stream: categorieBloc.getAllCategorie(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.length == 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Please add Categorie',
                  style: TextStyles.body,
                ),
              );
            } 
            return DataTable(
              dataRowHeight: 30,
              columns: [
                DataColumn(
                  label: Text('Nom categorie'),
                ),
                DataColumn(
                  label: Text('Delete'),
                ),
              ], 
              rows: snapshot.data
                .map((categorie) => DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text(categorie.nomCategorie),
                      onTap: () {
                        categorieBloc.changeId(categorie.id);
                        categorieBloc.changeIdCategorie(categorie.idCategorie);
                        categorieBloc.changeNomCategorie(categorie.nomCategorie);
                        setState(() {
                          _controller.text = categorie.nomCategorie;
                        });
                      }
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: AppColors.red,  
                        onPressed: () {
                          categorieBloc.deleteCategorie(categorie.id);
                          refreshList(categorieBloc);
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

