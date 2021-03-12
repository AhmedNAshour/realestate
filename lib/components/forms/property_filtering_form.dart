import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:realestate/components/forms/rounded_button..dart';
import 'package:realestate/constants.dart';
import 'package:realestate/models/location.dart';
import 'package:realestate/services/database.dart';

class FilterPropertiesForm extends StatefulWidget {
  const FilterPropertiesForm({
    Key key,
    this.changeGovernateFilter,
    this.changeDistrictFilter,
    this.changeAreaFilter,
    this.changeNumBedroomsFilter,
    this.changeNumBathroomsFilter,
    this.changePriceMaxFilter,
    this.changePriceMinFilter,
    this.changeListingTypeFilter,
    this.numBedroomsFilter,
    this.numBathroomsFilter,
    this.priceMinFilter,
    this.priceMaxFilter,
    this.listingTypeFilter,
    this.propertyTypeFilter,
    this.governateFilter,
    this.districtFilter,
    this.areaFilter,
    this.sizeMinFilter,
    this.sizeMaxFilter,
    this.changeSizeMinFilter,
    this.changeSizeMaxFilter,
  }) : super(key: key);

  final Function changeGovernateFilter;
  final Function changeDistrictFilter;
  final Function changeAreaFilter;
  final Function changeNumBedroomsFilter;
  final Function changeNumBathroomsFilter;
  final Function changeSizeMinFilter;
  final Function changeSizeMaxFilter;

  final Function changePriceMaxFilter;
  final Function changePriceMinFilter;
  final Function changeListingTypeFilter;
  final String governateFilter;
  final String districtFilter;
  final String areaFilter;

  final int numBedroomsFilter;
  final int numBathroomsFilter;
  final int sizeMinFilter;
  final int sizeMaxFilter;
  final int priceMinFilter;
  final int priceMaxFilter;
  final int listingTypeFilter;
  final int propertyTypeFilter;
  // final Function changePropertyTypeFilter;

  @override
  _FilterPropertiesFormState createState() => _FilterPropertiesFormState();
}

class _FilterPropertiesFormState extends State<FilterPropertiesForm> {
  int listingType;
  int numBedrooms;
  int numBathrooms;
  String selectedGov = '';
  String selectedDistrict = '';
  String selectedArea = '';
  List<Location> districts;
  List<Location> areas;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listingType = widget.listingTypeFilter;
    selectedGov = widget.governateFilter;
    selectedDistrict = widget.districtFilter;
    selectedArea = widget.areaFilter;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Location> governates = Provider.of<List<Location>>(context) ?? [];
    return StreamBuilder<List<Location>>(
        stream: selectedGov != ''
            ? DatabaseService().getDistricts(selectedGov)
            : null,
        builder: (context, districtsSnapshot) {
          districtsSnapshot.hasData
              ? districts = districtsSnapshot.data
              : districts = [];
          return StreamBuilder<Object>(
              stream: selectedDistrict != ''
                  ? DatabaseService().getAreas(selectedGov, selectedDistrict)
                  : null,
              builder: (context, areasSnapshot) {
                areasSnapshot.hasData ? areas = areasSnapshot.data : areas = [];
                return SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Listing type',
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              // horizontal: size.width * 0.05,
                              ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      listingType = 0;
                                      widget
                                          .changeListingTypeFilter(listingType);
                                    });
                                  },
                                  child: Container(
                                    // width: size.width * 0.35,
                                    // height: size.height * 0.07,
                                    padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.02,
                                      horizontal: size.width * 0.04,
                                    ),
                                    decoration: BoxDecoration(
                                      color: listingType == 0
                                          ? kPrimaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: listingType == 0
                                            ? Colors.transparent
                                            : kSecondaryColor,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Rent',
                                        style: TextStyle(
                                          color: listingType == 0
                                              ? Colors.white
                                              : kPrimaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      listingType = 1;
                                      widget
                                          .changeListingTypeFilter(listingType);
                                    });
                                  },
                                  child: Container(
                                    // width: size.width * 0.35,
                                    // height: size.height * 0.07,
                                    padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.02,
                                      horizontal: size.width * 0.04,
                                    ),
                                    decoration: BoxDecoration(
                                      color: listingType == 1
                                          ? kPrimaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: listingType == 1
                                            ? Colors.transparent
                                            : kSecondaryColor,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Buy',
                                        style: TextStyle(
                                          color: listingType == 1
                                              ? Colors.white
                                              : kPrimaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          'Bedrooms - Bathrooms',
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: TextFormField(
                                  initialValue: widget.numBedroomsFilter != null
                                      ? widget.numBedroomsFilter.toString()
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: 'Bedrooms',
                                    labelStyle: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.bed,
                                    ),
                                    hintText: 'Bedrooms',
                                    focusColor: kPrimaryColor,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    widget.changeNumBedroomsFilter(
                                        int.parse(value));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: TextFormField(
                                  initialValue:
                                      widget.numBathroomsFilter != null
                                          ? widget.numBathroomsFilter.toString()
                                          : null,
                                  decoration: InputDecoration(
                                    labelText: 'Bathrooms',
                                    labelStyle: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.bath,
                                    ),
                                    hintText: 'Bathrooms',
                                    focusColor: kPrimaryColor,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    widget.changeNumBathroomsFilter(
                                        int.parse(value));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Price range',
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: TextFormField(
                                  initialValue: widget.priceMinFilter != null
                                      ? widget.priceMinFilter.toString()
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: 'Min. Price',
                                    labelStyle: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.moneyBill,
                                    ),
                                    hintText: 'Min. Price',
                                    focusColor: kPrimaryColor,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    widget
                                        .changePriceMinFilter(int.parse(value));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: TextFormField(
                                  initialValue: widget.priceMaxFilter != null
                                      ? widget.priceMaxFilter.toString()
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: 'Max. Price',
                                    labelStyle: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.moneyBill,
                                    ),
                                    hintText: 'Max. Price',
                                    focusColor: kPrimaryColor,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    widget
                                        .changePriceMaxFilter(int.parse(value));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Size range',
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: TextFormField(
                                  initialValue: widget.sizeMinFilter != null
                                      ? widget.sizeMinFilter.toString()
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: 'Min. Size',
                                    labelStyle: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.ruler,
                                    ),
                                    hintText: 'Min. Size',
                                    focusColor: kPrimaryColor,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    widget
                                        .changeSizeMinFilter(int.parse(value));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: TextFormField(
                                  initialValue: widget.sizeMaxFilter != null
                                      ? widget.sizeMaxFilter.toString()
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: 'Max. Size',
                                    labelStyle: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.ruler,
                                    ),
                                    hintText: 'Max. Size',
                                    focusColor: kPrimaryColor,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    widget
                                        .changeSizeMaxFilter(int.parse(value));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Location',
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          height: 60,
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            icon: Icon(
                              Icons.pin_drop,
                              color: kPrimaryColor,
                            ),
                            hint: Text(
                              selectedGov == '' ? 'Governates' : selectedGov,
                            ),
                            items: governates.map((gov) {
                              return DropdownMenuItem(
                                value: gov.docId,
                                child: Text('${gov.docId}'),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() {
                              selectedGov = val;
                              selectedDistrict = '';
                              selectedArea = '';
                              widget.changeGovernateFilter(selectedGov);
                              widget.changeDistrictFilter('');
                              widget.changeAreaFilter('');
                            }),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        districts.length != 0
                            ? Container(
                                height: 60,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(29),
                                ),
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  icon: Icon(
                                    Icons.pin_drop,
                                    color: kPrimaryColor,
                                  ),
                                  hint: Text(
                                    selectedDistrict == ''
                                        ? 'Districts'
                                        : selectedDistrict,
                                  ),
                                  items: districts.map((district) {
                                    return DropdownMenuItem(
                                      value: district.docId,
                                      child: Text('${district.docId}'),
                                    );
                                  }).toList(),
                                  onChanged: (val) => setState(() {
                                    selectedDistrict = val;
                                    selectedArea = '';
                                    widget
                                        .changeDistrictFilter(selectedDistrict);

                                    widget.changeAreaFilter('');
                                  }),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        areas.length != 0
                            ? Container(
                                height: 60,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(29),
                                ),
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  icon: Icon(
                                    Icons.pin_drop,
                                    color: kPrimaryColor,
                                  ),
                                  hint: Text(
                                    selectedArea == '' ? 'Areas' : selectedArea,
                                  ),
                                  items: areas.map((area) {
                                    return DropdownMenuItem(
                                      value: area.docId,
                                      child: Text('${area.docId}'),
                                    );
                                  }).toList(),
                                  onChanged: (val) => setState(() {
                                    selectedArea = val;
                                    widget.changeAreaFilter(selectedArea);
                                  }),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Center(
                          child: RoundedButton(
                            text: 'FILTER',
                            press: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
