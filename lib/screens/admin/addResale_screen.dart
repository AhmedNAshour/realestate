import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:realestate/components/forms/rounded_button..dart';
import 'package:realestate/components/forms/rounded_input_field.dart';
import 'package:realestate/components/offers-carousel.dart';
import 'package:realestate/models/user.dart';
import 'package:realestate/screens/shared/added.dart';
import 'package:realestate/screens/shared/loading.dart';
import 'package:realestate/services/database.dart';
import 'dart:io';
import 'package:realestate/constants.dart';
import 'package:smart_select/smart_select.dart';
import 'package:geocoder/geocoder.dart' as geoco;
import 'package:geolocator/geolocator.dart' as go;

class AddResale extends StatefulWidget {
  static const id = 'AddResale';
  @override
  _AddResaleState createState() => _AddResaleState();
}

class _AddResaleState extends State<AddResale> {
  // AuthService _auth = AuthService();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position currentPosition;
  var geoLocator = Geolocator();
  GoogleMapController newGoogleMapContoller;

  // text field state
  int numberBathrooms;
  int numberBedrooms;
  String error = '';
  int price;
  String type = '';
  int listingType = 0;
  int unitSize;
  bool loading = false;
  double latitude;
  double longitude;
  List<File> images = <File>[];
  List<String> imagesURLs = <String>[];
  bool added = false;

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

  String value = 'Villa';
  List<S2Choice<String>> types = [
    S2Choice<String>(value: 'Villa', title: 'Villa'),
    S2Choice<String>(value: 'Apartment', title: 'Apartment'),
    S2Choice<String>(value: 'Vacation', title: 'Vacation'),
    S2Choice<String>(value: 'Commercial', title: 'Commercial'),
  ];

  List<String> amenitiesValue = ['Balcony'];
  List<S2Choice<String>> amenities = [
    S2Choice<String>(value: 'Balcony', title: 'Balcony'),
    S2Choice<String>(
        value: 'Built in Kitchen Appliances',
        title: 'Built in Kitchen Appliances'),
    S2Choice<String>(value: 'Private Garden', title: 'Private Garden'),
    S2Choice<String>(
        value: 'Central A/C & heating', title: 'Central A/C & heating'),
    S2Choice<String>(value: 'Security', title: 'Security'),
    S2Choice<String>(value: 'Covered Parking', title: 'Covered Parking'),
    S2Choice<String>(value: 'Maids Room', title: 'Maids Room'),
    S2Choice<String>(value: 'Pets Allowed', title: 'Pets Allowed'),
    S2Choice<String>(value: 'Pool', title: 'Pool'),
    S2Choice<String>(value: 'Electricity Meter', title: 'Electricity Meter'),
    S2Choice<String>(value: 'Water Meter', title: 'Water Meter'),
    S2Choice<String>(value: 'Natural Gas', title: 'Natural Gas'),
    S2Choice<String>(value: 'Landline', title: 'Landline'),
    S2Choice<String>(value: 'Elevator', title: 'Elevator'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    locationData = ModalRoute.of(context).settings.arguments;
    CameraPosition selectedPosition = CameraPosition(
      target: LatLng(locationData['latitude'], locationData['longitude']),
      zoom: 14.4746,
    );
    return added
        ? Added('Property')
        : loading
            ? Loading()
            : StreamBuilder<UserData>(
                stream: DatabaseService(uid: user.uid).userData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserData userData = snapshot.data;
                    return Scaffold(
                      backgroundColor: kPrimaryLightColor,
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 30),
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
                                            initialCameraPosition:
                                                selectedPosition,
                                            markers:
                                                Set<Marker>.of(markers.values),
                                          ),
                                        ),
                                        SizedBox(height: height * 0.02),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    listingType = 0;
                                                  });
                                                },
                                                child: Container(
                                                  // width: size.width * 0.35,
                                                  // height: size.height * 0.07,
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        size.height * 0.02,
                                                    horizontal:
                                                        size.width * 0.04,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: listingType == 0
                                                        ? kPrimaryColor
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: listingType == 0
                                                          ? Colors.transparent
                                                          : kPrimaryLightColor,
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
                                                  });
                                                },
                                                child: Container(
                                                  // width: size.width * 0.35,
                                                  // height: size.height * 0.07,
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        size.height * 0.02,
                                                    horizontal:
                                                        size.width * 0.04,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: listingType == 1
                                                        ? kPrimaryColor
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: listingType == 1
                                                          ? Colors.transparent
                                                          : kPrimaryLightColor,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Sell',
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
                                        SizedBox(height: height * 0.02),
                                        SmartSelect<String>.single(
                                          title: 'Unit type',
                                          value: value,
                                          choiceItems: types,
                                          onChange: (state) => setState(() {
                                            value = state.value;
                                          }),
                                          modalType: S2ModalType.popupDialog,
                                          choiceType: S2ChoiceType.chips,
                                        ),
                                        SizedBox(height: height * 0.02),
                                        SmartSelect<String>.multiple(
                                          title: 'Amenities',
                                          value: amenitiesValue,
                                          choiceItems: amenities,
                                          onChange: (state) => setState(() {
                                            amenitiesValue = state.value;
                                          }),
                                          modalType: S2ModalType.popupDialog,
                                          choiceType: S2ChoiceType.chips,
                                        ),
                                        SizedBox(height: height * 0.02),
                                        RoundedInputField(
                                          textInputType: TextInputType.number,
                                          obsecureText: false,
                                          icon: FontAwesomeIcons.moneyBill,
                                          hintText: listingType == 1
                                              ? 'Price'
                                              : 'Price/Month',
                                          onChanged: (val) {
                                            setState(
                                                () => price = int.parse(val));
                                          },
                                          validator: (val) => val.isEmpty ||
                                                  int.tryParse(val) == null
                                              ? 'Enter a valid price'
                                              : null,
                                        ),
                                        RoundedInputField(
                                          textInputType: TextInputType.number,
                                          obsecureText: false,
                                          icon: FontAwesomeIcons.bed,
                                          hintText: 'Number of bedrooms',
                                          onChanged: (val) {
                                            setState(() => numberBedrooms =
                                                int.parse(val));
                                          },
                                          validator: (val) => val.isEmpty ||
                                                  int.tryParse(val) == null
                                              ? 'Enter a valid number'
                                              : null,
                                        ),
                                        RoundedInputField(
                                          textInputType: TextInputType.number,
                                          obsecureText: false,
                                          icon: FontAwesomeIcons.bath,
                                          hintText: 'Number of bathrooms',
                                          onChanged: (val) {
                                            setState(() => numberBathrooms =
                                                int.parse(val));
                                          },
                                          validator: (val) => val.isEmpty ||
                                                  int.tryParse(val) == null
                                              ? 'Enter a valid number'
                                              : null,
                                        ),
                                        RoundedInputField(
                                          textInputType: TextInputType.number,
                                          obsecureText: false,
                                          icon: FontAwesomeIcons.ruler,
                                          hintText: 'Size in meters squared',
                                          onChanged: (val) {
                                            setState(() =>
                                                unitSize = int.parse(val));
                                          },
                                          validator: (val) => val.isEmpty ||
                                                  int.tryParse(val) == null
                                              ? 'Enter a valid number'
                                              : null,
                                        ),
                                        RoundedButton(
                                          text: 'Add',
                                          press: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              if (images.length == 0) {
                                                setState(() {
                                                  error = 'Please add images';
                                                });
                                              } else {
                                                setState(() {
                                                  loading = true;
                                                });
                                                dynamic result;
                                                String id = FirebaseFirestore
                                                    .instance
                                                    .collection('resale')
                                                    .doc()
                                                    .id;
                                                imagesURLs =
                                                    await DatabaseService()
                                                        .getDownloadURLs(
                                                            images, id);
                                                await DatabaseService()
                                                    .updatePropertyData(
                                                  amenities: amenitiesValue,
                                                  imagesURLs: imagesURLs,
                                                  numberBathrooms:
                                                      numberBathrooms,
                                                  numberBedrooms:
                                                      numberBedrooms,
                                                  price: price,
                                                  type: value,
                                                  latitude:
                                                      locationData['latitude'],
                                                  longitude:
                                                      locationData['longitude'],
                                                  governate:
                                                      locationData['govName'],
                                                  district: locationData[
                                                      'districtName'],
                                                  area:
                                                      locationData['areaName'],
                                                  size: unitSize,
                                                  listingType: listingType,
                                                  userId: user.uid,
                                                  userName: userData.name,
                                                  userNumber:
                                                      userData.phoneNumber,
                                                  userPic: userData.picURL,
                                                  userRole: userData.role,
                                                  userEmail: userData.email,
                                                  userGender: userData.gender,
                                                  status:
                                                      userData.role == 'admin'
                                                          ? 'active'
                                                          : 'pending',
                                                );
                                                setState(() {
                                                  added = true;
                                                });
                                              }
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          error,
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 14),
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
                  } else {
                    return Loading();
                  }
                });
  }
}
