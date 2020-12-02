import 'package:flutter/material.dart';
import 'package:grocery_manager/blocs/produit_bloc.dart';
import 'package:grocery_manager/main.dart';
import 'package:grocery_manager/models/produits.dart';
import 'package:grocery_manager/widgets/app_button.dart';
import 'package:grocery_manager/widgets/dropdown_button.dart';
import 'package:grocery_manager/widgets/my_text_field.dart';
import 'package:provider/provider.dart';
import 'package:grocery_manager/widgets/toast.dart';


class AjouterEditerProduit extends StatefulWidget {
  final String produitId;

  AjouterEditerProduit({
    this.produitId
  });

  @override
  _AjouterEditerProduitState createState() => _AjouterEditerProduitState();
}

class _AjouterEditerProduitState extends State<AjouterEditerProduit> {

  TextEditingController _nomProduitController = TextEditingController();
  TextEditingController _quantiteProduitController = TextEditingController();
  TextEditingController _prixDachatProduitController = TextEditingController();
  TextEditingController _prixDeVenteProduitController = TextEditingController();
  TextEditingController _prixDeGrosProduitController = TextEditingController();
  TextEditingController _pourcentageGrosProduitController = TextEditingController();
  TextEditingController _pourcentageDetailsProduitController = TextEditingController();

  List<DropdownMenuItem<String>> listDropdownItemUnite = List<DropdownMenuItem<String>>();
  List<DropdownMenuItem<String>> listDropdownItemCategorie = List<DropdownMenuItem<String>>();

  String valueUnite;
  String valueCategorie;
  String valueUniteAchat;

  Produit existingProduit;
  Future<Produit> produit;

  changeState() {
    produitBloc.calculerPrix();
    setState(() {
      _prixDeGrosProduitController.text = produitBloc.getValueGros();
      _prixDeVenteProduitController.text = produitBloc.getValueDetails();
    });
  }

  getDropDownItem() {
    listDropdownItemUnite.clear();
    listDropdownItemCategorie.clear();

    uniteBloc.getAllUniteFuture().then((listMap){
      listMap.map((map) {
        return DropdownMenuItem<String> (
          value: map.nomUnite,
          child: Text(map.nomUnite),
        );
      }).forEach((dropdownItem) {
        listDropdownItemUnite.add(dropdownItem);
      });
    });

    categorieBloc.getAllCategorieFuture().then((listMap){
      listMap.map((map) {
        return DropdownMenuItem<String> (
          value: map.nomCategorie,
          child: Text(map.nomCategorie),
        );
      }).forEach((dropdownItem) {
        listDropdownItemCategorie.add(dropdownItem);
      });
    });
  }

  @override
  void initState() {
    // toast 
    var produitBloc = Provider.of<ProduitBloc>(context, listen: false);
    produitBloc.produitSaved.listen((saved) {
      if (saved != null && saved == true && context != null) {
        showToastFunction("Produit enregistrer");
        produitBloc.changeRefresh(true);
        Navigator.of(context).pop();
      }
    });

    produitBloc.produitEdited.listen((edited) {
      if (edited != null && edited == true && context != null) {
        showToastFunction("Produit editer");
        produitBloc.changeRefresh(true);
        Navigator.of(context).pop();
      }
    });

    categorieBloc.navigatorIsPoped.listen((poped) {
      if (poped != null && poped == true && context != null) {
        getDropDownItem();
        categorieBloc.changeNavigatorPoped(null);
      }
    });

    uniteBloc.navigatorIsPoped.listen((poped) {
      if (poped != null && poped == true && context != null) {
        getDropDownItem();
        print('called unit bloc poped');
        uniteBloc.changeNavigatorPoped(null);
      }
    });

    // Building the dropdown item
    getDropDownItem();

    if (widget.produitId == null) {
      produitBloc.initCalculator();
      setState(() {
        _nomProduitController.text = "";
        _prixDachatProduitController.text = "1";
        _quantiteProduitController.text = "1";
        _pourcentageGrosProduitController.text = "1.1";
        _pourcentageDetailsProduitController.text = "1.1";
        _prixDeGrosProduitController.text = '0';
        _prixDeVenteProduitController.text = "0";
      });
    }
    // load produit
    if ( widget.produitId != null) {
      produit = produitBloc.getProduitById(widget.produitId);
      produit.then((element) {
        produitBloc.loadProduit(element);
        setState(() {
          _nomProduitController.text = element.nomProduit;
          _prixDachatProduitController.text = element.prixDachatProduit.toString();
          _quantiteProduitController.text = element.quantiteProduit.toString();
          _pourcentageGrosProduitController.text = element.pourcentageGrosProduit.toString();
          _pourcentageDetailsProduitController.text = element.pourcentageDetailsProduit.toString();
          _prixDeGrosProduitController.text = element.prixDeGrosProduit.toString();
          _prixDeVenteProduitController.text = element.prixDeVenteProduit.toString();  
        });
      });
    }

    super.initState();
  }

  // Future<bool> showToastFunction() {
  //   return Fluttertoast.showToast(
  //     msg: "Produit sauvegarder",
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.CENTER,
  //     timeInSecForIosWeb: 2,
  //     backgroundColor: AppColors.lightblue,
  //     textColor: Colors.white,
  //     fontSize: 16.0
  //   );
  // }
  
  @override
  void dispose() {
    // _savedSubscription.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var produitBloc = Provider.of<ProduitBloc>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: FutureBuilder<Produit>(
        future: produitBloc.getProduitById(widget.produitId),
        builder: (context, snapshot) {
          if(!snapshot.hasData && widget.produitId != null) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
          }

          if (widget.produitId != null) {
            // Edit logic
            existingProduit = snapshot.data;
            produitBloc.loadProduit(existingProduit);  
            // _prixDeGros.text = produitBloc.getValueGros();
            // _prixDeVente.text = produitBloc.getValueDetails();      
          } 

          return _buildBodyScaffold(produitBloc, context);
        }
      ),
    );
  }

  // loadValue(ProduitBloc produitBloc, Produit produit) {
  //   produitBloc.changeId(produit.id);
  //   produitBloc.changeIdProduit(produit.idProduit);
  //   produitBloc.changeNomProduit(produit.nomProduit);
  //   produitBloc.changeQuantiteProduit(produit.quantiteProduit.toString());
  //   produitBloc.changePrixDachatProduit(produit.prixDachatProduit.toString());
  //   produitBloc.changePrixDeVenteProduit(produit.prixDeVenteProduit.toString());
  //   produitBloc.changePrixDeGrosProduit(produit.prixDeGrosProduit.toString());
  //   produitBloc.changeUniteProduit(produit.uniteProduit);
  //   produitBloc.changeCategorieProduit(produit.categorieProduit);
  //   produitBloc.changePourcentageGrosProduit(produit.pourcentageGrosProduit.toString());
  //   produitBloc.changePourcentageDetailsProduit(produit.pourcentageDetailsProduit.toString());
  //   produitBloc.changeUniteAchatProduit(produit.uniteAchatProduit);
  //   produitBloc.changeProduitElement(produit);
  // }

  Scaffold _buildBodyScaffold(ProduitBloc produitBloc, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget.produitId == null)
          ? Text('Ajouter un produit')
          : Text('Editer produit'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            produitBloc.refreshAll();
            Navigator.of(context).pop();
          },
        ),
      ),  
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _streamBuilderNomProduit(produitBloc),
            _streamBuilderQuantiteProduit(produitBloc),
            _streamBuilderPrixDachatProduit(produitBloc),
            _streamBuilderPourcentageDeGrosProduit(produitBloc),
            _streamBuilderPourcentageDetails(produitBloc),
            _streamBuilderPrixDeVenteProduit(produitBloc),
            _streamBuilderPrixDeGrosProduit(produitBloc),
            _appDropdownButtonUniteDachatProduit(context, produitBloc),
            _appDropdownButtonUniteDeVente(context, produitBloc),
            _appDropdownButtonCategorieProduit(produitBloc, context),
            _rowBuilderButton(produitBloc, context),
          ]
        ),
      ),
    );
  }

  Row _rowBuilderButton(ProduitBloc produitBloc, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<bool>(
          stream: produitBloc.isValid,
          builder: (context, isValidStream) {
            return AppButton(
              buttonText: (widget.produitId == null) 
                ? 'Ajouter'
                : 'Editer',
              buttonType: (isValidStream.data == true) 
                ? ButtonType.Green
                : ButtonType.Disabled,
              onPressed: () {
                produitBloc.changeNomProduit(_nomProduitController.text);
                produitBloc.changeQuantiteProduit(_quantiteProduitController.text);
                produitBloc.changePrixDachatProduit(_prixDachatProduitController.text);
                produitBloc.changePourcentageGrosProduit(_pourcentageGrosProduitController.text);
                produitBloc.changePourcentageDetailsProduit(_pourcentageDetailsProduitController.text);
                produitBloc.changePrixDeVenteProduit(_prixDeVenteProduitController.text);
                produitBloc.changePrixDeGrosProduit(_prixDeGrosProduitController.text);
                produitBloc.changeUniteAchatProduit(valueUniteAchat);
                produitBloc.changeUniteProduit(valueUnite);
                produitBloc.changeCategorieProduit(valueCategorie);
                produitBloc.saveOrUpdateProduit();
              } ,
            );
          }
        ),
        AppButton(
          buttonText: 'Annuler',
          buttonType: ButtonType.Red,
          onPressed: () {
            produitBloc.refreshAll();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  AppDropdownButton _appDropdownButtonCategorieProduit(ProduitBloc produitBloc, BuildContext context) {
    return AppDropdownButton(
      // labelText: "choissiser un categorie:",
      hintText: "Choisiser un categorie",
      dropdownItem: listDropdownItemCategorie,
      onChanged: (newValue) {
        produitBloc.changeCategorieProduit(newValue);
        produitBloc.printAllStreamValue();
        setState(() {
          valueCategorie = newValue;
        });
      },
      onPressedIcon: () => Navigator.of(context).pushNamed('/listeCategorie'),
      value: valueCategorie,
      initialValue: (widget.produitId == null)
        ? null
        : null,
        // : existingProduit.categorieProduit,
    );
  }

  AppDropdownButton _appDropdownButtonUniteDeVente(BuildContext context, ProduitBloc produitBloc) {
    return AppDropdownButton(
      // labelText: "Choissiser une uniter:",
      hintText: "Choisiser une unité de vente",
      dropdownItem: listDropdownItemUnite,
      onPressedIcon: () => Navigator.of(context).pushNamed('/listeUnite'),
      onChanged: (newValue) {
        produitBloc.changeUniteProduit(newValue);
        produitBloc.printAllStreamValue();
        setState(() {
          valueUnite = newValue;
        });
      },
      value: valueUnite,
      initialValue: (widget.produitId == null)
        ? null
        : null,
        // : existingProduit.uniteProduit,
    );
  }

  AppDropdownButton _appDropdownButtonUniteDachatProduit(BuildContext context, ProduitBloc produitBloc) {
    return AppDropdownButton(
      // labelText: "Choissiser une uniter:",
      hintText: "Choisiser une unité d'achat",
      dropdownItem: listDropdownItemUnite,
      onPressedIcon: () => Navigator.of(context).pushNamed('/listeUnite'),
      onChanged: (newValue) {
        produitBloc.changeUniteAchatProduit(newValue);
        produitBloc.printAllStreamValue();
        setState(() {
          valueUniteAchat = newValue;
        });
      },
      value: valueUniteAchat,
      initialValue: (widget.produitId == null)
        ? null
        : null,
        // : existingProduit.uniteAchatProduit,
    );
  }

  StreamBuilder<double> _streamBuilderPrixDeGrosProduit(ProduitBloc produitBloc) {
    return StreamBuilder<double>(
      stream: produitBloc.prixDeGrosProduit,
      builder: (context, snapshot) {
        return MyTextField(
          hintText: "Prix de gros",
          labelText: "Entrer le prix de gros du produit",
          textInputType: TextInputType.number,
          errorText: snapshot.error,
          textController: _prixDeGrosProduitController,
          onChanged: (value) {
            produitBloc.changePrixDeGrosProduit(value);
            // produitBloc.printAllStreamValue();
          },
          initialText: (widget.produitId == null)
            ? ''
            : existingProduit.prixDeGrosProduit.toString(),
        );
      }
    );
  }

  StreamBuilder<double> _streamBuilderPrixDeVenteProduit(ProduitBloc produitBloc) {
    return StreamBuilder<double>(
      stream: produitBloc.prixDeVenteProduit,
      builder: (context, snapshot) {
        return MyTextField(
          hintText: "Prix de vente",
          labelText: 'Entrer le prix de vente du produit :',
          textInputType: TextInputType.number,
          errorText: snapshot.error,
          textController: _prixDeVenteProduitController,
          onChanged: (value) {
            produitBloc.changePrixDeVenteProduit(value);
            // produitBloc.printAllStreamValue();
          },
          initialText: (widget.produitId == null)
            ? ''
            : existingProduit.prixDeVenteProduit.toString(),
        );
      }
    );
  }

  StreamBuilder<double> _streamBuilderPourcentageDetails(ProduitBloc produitBloc) {
    return StreamBuilder<double>(
      stream: produitBloc.pourcentageDetailsProduit,
      builder: (context, snapshot) {
        return MyTextField(
          hintText: "Pourcentage de detail",
          labelText: "Entrer le Prix d'achat du produit :",
          textInputType: TextInputType.number,
          errorText: snapshot.error,
          textController: _pourcentageDetailsProduitController,
          onChanged: (value) {
            produitBloc.changePourcentageDetailsProduit(value);
            // produitBloc.calculerPrix();
            // produitBloc.printAllStreamValue();
            changeState();
          },
          initialText: (widget.produitId == null)
            ? '1.1'
            : existingProduit.pourcentageDetailsProduit.toString(),
        );
      }
    );
  }

  StreamBuilder<double> _streamBuilderPourcentageDeGrosProduit(ProduitBloc produitBloc) {
    return StreamBuilder<double>(
      stream: produitBloc.pourcentageGrosProduit,
      builder: (context, snapshot) {
        return MyTextField(
          hintText: "Pourcentage de gros",
          labelText: "Entrer le Prix d'achat du produit :",
          textInputType: TextInputType.number,
          errorText: snapshot.error,
          textController: _pourcentageGrosProduitController,
          onChanged: (value) {
            produitBloc.changePourcentageGrosProduit(value);
            // produitBloc.calculerPrix();
            // produitBloc.printAllStreamValue();
            changeState();
          },
          initialText: (widget.produitId == null)
            ? '1.1'
            : existingProduit.pourcentageGrosProduit.toString(),
        );
      }
    );
  }

  StreamBuilder<double> _streamBuilderPrixDachatProduit(ProduitBloc produitBloc) {
    return StreamBuilder<double>(
      stream: produitBloc.prixDachatProduit,
      builder: (context, snapshot) {
        return MyTextField(
          hintText: "Prix d'achat",
          labelText: "Entrer le Prix d'achat du produit :",
          textInputType: TextInputType.number,
          errorText: snapshot.error,
          textController: _prixDachatProduitController,
          onChanged: (value) {
            produitBloc.changePrixDachatProduit(value);
            // produitBloc.calculerPrix();
            // produitBloc.printAllStreamValue();
            changeState();
          },
          initialText: (widget.produitId == null)
            ? '1'
            : existingProduit.prixDachatProduit.toString(),
        );
      }
    );
  }

  StreamBuilder<int> _streamBuilderQuantiteProduit(ProduitBloc produitBloc) {
    return StreamBuilder<int>(
      stream: produitBloc.quantiteProduit,
      builder: (context, snapshot) {
        return MyTextField(
          hintText: "Quantite du produit",
          labelText: "Entrer la quantite du produit :",
          textInputType: TextInputType.number,
          errorText: snapshot.error,
          textController: _quantiteProduitController,
          onChanged: (value) {
            produitBloc.changeQuantiteProduit(value);
            // produitBloc.calculerPrix();
            // produitBloc.printAllStreamValue();
            changeState();
          },
          initialText: (widget.produitId == null)
            ? '1'
            : existingProduit.quantiteProduit.toString(),
        );
      }
    );
  }

  StreamBuilder<String> _streamBuilderNomProduit(ProduitBloc produitBloc) {
    return StreamBuilder<String>(
      stream: produitBloc.nomProduit,
      builder: (context, snapshot) {
        return MyTextField(
          hintText: "Nom du produit",
          labelText: "Entrer le nom du produit :",
          errorText: snapshot.error,
          textController: _nomProduitController,
          onChanged: (value) {
            // print(_nomProduitController.text);
            produitBloc.changeNomProduit(value);
            // produitBloc.printAllStreamValue();
          },
          initialText: (widget.produitId == null)
            ? ""
            : existingProduit.nomProduit,
        );
      }
    );
  }
}