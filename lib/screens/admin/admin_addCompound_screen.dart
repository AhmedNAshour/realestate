import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realestate/components/forms/rounded_button..dart';
import 'package:realestate/components/forms/rounded_input_field.dart';
import 'package:realestate/components/forms/text_field_container.dart';
import 'package:realestate/components/offers-carousel.dart';
import 'package:realestate/screens/shared/loading.dart';
import 'package:realestate/services/database.dart';
import 'dart:io';
import 'package:realestate/constants.dart';
import 'package:smart_select/smart_select.dart';
import 'package:geocoder/geocoder.dart' as geoco;
import 'package:geolocator/geolocator.dart' as go;
import 'package:intl/intl.dart';

class AdminAddCompound extends StatefulWidget {
  static const id = 'AddCompound';
  @override
  _AdminAddCompoundState createState() => _AdminAddCompoundState();
}

class _AdminAddCompoundState extends State<AdminAddCompound> {
  // AuthService _auth = AuthService();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position currentPosition;
  var geoLocator = Geolocator();
  GoogleMapController newGoogleMapContoller;

  // text field state
  String name = '';
  String location = '';
  String description = '';
  String meterPrice = '';
  String installementPlan = '';
  String error = '';
  String deliveryDate = '';
  String unitTypes = '';
  String availableUnitAreas = '';
  String pictures = '';
  bool loading = false;
  List<File> images = <File>[];
  List<String> imagesURLs = <String>[];

  Future getImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg'],
    );

    if (result != null) {
      setState(() {
        images = result.paths.map((path) => File(path)).toList();
      });
    } else {
      // User canceled the picker
    }
  }

  Map locationData = {};

  final _formKey = GlobalKey<FormState>();

  List<String> value = ['Villa'];
  List<S2Choice<String>> frameworks = [
    S2Choice<String>(value: 'Villa', title: 'Villa'),
    S2Choice<String>(value: 'Apartment', title: 'Apartment'),
  ];
  var dateTextController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    locationData = ModalRoute.of(context).settings.arguments;
    CameraPosition selectedPosition = CameraPosition(
      target: LatLng(locationData['latitude'], locationData['longitude']),
      zoom: 14.4746,
    );
    return loading
        ? Loading()
        : Scaffold(
            body: Stack(
              children: [
                OffersCarousel(
                  images: images,
                ),
                Positioned(
                  top: height * 0.05,
                  left: width * 0.05,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3000),
                    child: Container(
                      color: kPrimaryLightColor,
                      height: height * 0.05,
                      width: height * 0.05,
                      child: BackButton(
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.05,
                  right: width * 0.05,
                  child: GestureDetector(
                    onTap: () async {
                      await getImage();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3000),
                      child: Container(
                        color: kPrimaryLightColor,
                        height: height * 0.05,
                        width: height * 0.05,
                        child: Icon(
                          FontAwesomeIcons.camera,
                          color: kSecondaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    width: double.infinity,
                    height: size.height * 0.65,
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(53),
                          topRight: Radius.circular(53)),
                    ),
                    child: Container(
                      // height: size.height * 0.5,
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.2,
                                child: GoogleMap(
                                  mapType: MapType.terrain,
                                  myLocationEnabled: true,
                                  zoomGesturesEnabled: true,
                                  zoomControlsEnabled: true,
                                  initialCameraPosition: selectedPosition,
                                  markers: Set<Marker>.of(markers.values),
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                              RoundedInputField(
                                obsecureText: false,
                                icon: FontAwesomeIcons.pen,
                                hintText: 'Name',
                                onChanged: (val) {
                                  setState(() => name = val);
                                },
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a name' : null,
                              ),
                              RoundedInputField(
                                obsecureText: false,
                                icon: FontAwesomeIcons.pen,
                                hintText: 'Description',
                                onChanged: (val) {
                                  setState(() => description = val);
                                },
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a description' : null,
                              ),
                              RoundedInputField(
                                obsecureText: false,
                                icon: FontAwesomeIcons.moneyBillAlt,
                                hintText: 'Meter Price',
                                onChanged: (val) {
                                  setState(() => meterPrice = val);
                                },
                                validator: (val) =>
                                    val.isEmpty || double.tryParse(val) == null
                                        ? 'Enter a valid price'
                                        : null,
                              ),
                              RoundedInputField(
                                textInputType: TextInputType.number,
                                obsecureText: false,
                                icon: FontAwesomeIcons.pen,
                                hintText: 'Installement Plan',
                                onChanged: (val) {
                                  setState(() => installementPlan = val);
                                },
                                validator: (val) => val.isEmpty
                                    ? 'Enter an installement plan'
                                    : null,
                              ),
                              RoundedInputField(
                                textInputType: TextInputType.number,
                                obsecureText: false,
                                icon: FontAwesomeIcons.ruler,
                                hintText: 'Available Unit Areas',
                                onChanged: (val) {
                                  setState(() => availableUnitAreas = val);
                                },
                                validator: (val) => val.isEmpty
                                    ? 'Enter available unit areas'
                                    : null,
                              ),
                              TextFieldContainer(
                                child: TextFormField(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030),
                                    ).then((value) => setState(() {
                                          if (value == null) {
                                            deliveryDate = '';
                                            dateTextController.text = '';
                                            // showCancel =
                                            //     false;
                                          } else {
                                            deliveryDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(value);

                                            dateTextController.text =
                                                DateFormat('yyyy')
                                                    .format(value);
                                          }
                                        }));
                                  },
                                  keyboardType: null,
                                  controller: dateTextController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Select Date',
                                      icon: Icon(
                                        FontAwesomeIcons.calendar,
                                        color: kPrimaryLightTextColor,
                                      )),
                                  onChanged: (val) {
                                    deliveryDate = val;
                                  },
                                  validator: (val) =>
                                      val.isEmpty ? 'Select a date' : null,
                                ),
                              ),
                              SmartSelect<String>.multiple(
                                title: 'Units types',
                                value: value,
                                choiceItems: frameworks,
                                onChange: (state) => setState(() {
                                  value = state.value;
                                  print(value);
                                }),
                                modalType: S2ModalType.popupDialog,
                                choiceType: S2ChoiceType.chips,
                              ),
                              SizedBox(height: height * 0.02),
                              RoundedButton(
                                text: 'Add',
                                press: () async {
                                  if (_formKey.currentState.validate()) {
                                    if (images.length == 0) {
                                      setState(() {
                                        error = 'Please add images';
                                      });
                                    } else {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result;
                                      imagesURLs = await DatabaseService()
                                          .getDownloadURLs(images, name);
                                      result = await DatabaseService()
                                          .updateCompoundData(
                                        name: name,
                                        imagesURLs: imagesURLs,
                                        meterPrice: int.parse(meterPrice),
                                        deliveryDate: deliveryDate,
                                        unitTypes: value,
                                        availableUnitAreas: availableUnitAreas,
                                        installementPlan:
                                            int.parse(installementPlan),
                                        description: description,
                                        latitude: locationData['latitude'],
                                        longitude: locationData['longitude'],
                                        governate: locationData['govName'],
                                        district: locationData['districtName'],
                                        area: locationData['areaName'],
                                        status: 'active',
                                        highlighted: true,
                                      );

                                      if (result == null) {
                                        setState(() {
                                          error = 'Upload failed';
                                          loading = false;
                                        });
                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                error,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
