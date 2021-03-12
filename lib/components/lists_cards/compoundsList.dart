import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realestate/components/lists_cards/compound_card.dart';
import 'package:realestate/models/compound.dart';
import 'package:realestate/models/property.dart';

class CompoundsList extends StatefulWidget {
  @override
  _CompoundsListState createState() => _CompoundsListState();
  List<Property> searchList = <Property>[];
  String search = '';
  Axis axis;
  CompoundsList(String search, Axis axis) {
    this.search = search;
    this.axis = axis;
  }

  CompoundsList.searchByFavorites(
      String search, Axis axis, List userFavorites) {
    this.search = search;
    this.axis = axis;
  }
}

class _CompoundsListState extends State<CompoundsList> {
  @override
  Widget build(BuildContext context) {
    List<Compound> compounds = Provider.of<List<Compound>>(context) ?? [];
    Size size = MediaQuery.of(context).size;

    if (compounds.length == 0) {
      return Center(
          child: Text('Unfortunately , no matching compounds exist :/'));
    }

    compounds.sort((a, b) {
      var aTitle = a.name; //before -> var adate = a.expiry;
      var bTitle = b.name; //before -> var bdate = b.expiry;
      return aTitle.compareTo(
          bTitle); //to get the order other way just switch `adate & bdate`
    });
    return ListView.builder(
      scrollDirection: widget.axis,
      itemCount: compounds.length,
      itemBuilder: (context, index) {
        return widget.axis == Axis.horizontal
            ? Row(
                children: [
                  CompoundCard(compound: compounds[index]),
                  SizedBox(
                    width: size.width * 0.04,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CompoundCard(compound: compounds[index]),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                ],
              );
      },
    );
  }
}
