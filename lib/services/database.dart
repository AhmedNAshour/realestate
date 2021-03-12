import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:realestate/models/compound.dart';
import 'package:realestate/models/governate.dart';
import 'package:realestate/models/location.dart';
import 'package:realestate/models/property.dart';
import 'package:realestate/models/request.dart';
import 'package:realestate/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection references
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference compoundsCollection =
      FirebaseFirestore.instance.collection('compounds');
  final CollectionReference propertiesCollection =
      FirebaseFirestore.instance.collection('resale');
  final CollectionReference locationsCollection =
      FirebaseFirestore.instance.collection('locations');
  final CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('requests');

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return UserData(
      uid: uid,
      name: data['name'],
      gender: data['gender'],
      role: data['role'],
      phoneNumber: data['phoneNumber'],
      password: data['password'],
      email: data['email'],
      picURL: data['picURL'],
      likes: data['likes'] ?? [],
    );
  }

  Stream<UserData> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // create or update government
  Future updateLocationData({
    String govName,
  }) async {
    return await FirebaseFirestore.instance
        .collection("locations/")
        .doc(govName)
        .set({});
  }

  Future updateLocationDataDistrict(
      {String districtName, String govName}) async {
    return await FirebaseFirestore.instance
        .collection("locations/" + govName + "/districts")
        .doc(districtName)
        .set({});
  }

  Future updateLocationDataArea(
      {String districtName, String govName, String areaName}) async {
    return await FirebaseFirestore.instance
        .collection(
            "locations/" + govName + "/districts/" + districtName + '/areas')
        .doc(areaName)
        .set({});
  }

  List<UserData> _usersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserData(
        name: doc.data()['name'] ?? '',
        phoneNumber: doc.data()['phoneNumber'] ?? '',
        gender: doc.data()['gender'] ?? '',
        uid: doc.id,
        picURL: doc.data()['picURL'] ?? '',
        email: doc.data()['email'] ?? '',
        role: doc.data()['role'] ?? '',
      );
    }).toList();
  }

  Stream<List<UserData>> getUsersBySearch(String role) {
    Query query = FirebaseFirestore.instance.collection('users');
    if (role != '') {
      query = query.where(
        'role',
        isEqualTo: role,
      );
    }
    return query.snapshots().map(_usersListFromSnapshot);
  }

  // create or update user
  Future updateUserData({
    String name,
    String phoneNumber,
    String gender,
    String role,
    String password,
    String email,
    String picURL,
    List likes,
  }) async {
    return await usersCollection.doc(uid).set({
      'name': name,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'role': role,
      'password': password,
      'email': email,
      'picURL': picURL,
      'likes': likes,
    });
  }

  Future updateUserLikes(List likes) async {
    await usersCollection.doc(uid).update({
      'likes': likes,
    });
  }

  Future updateUserProfilePicture(String picURL) async {
    await usersCollection.doc(uid).update({
      'picURL': picURL,
    });
  }

  Future<List<String>> getDownloadURLs(List<File> images, String name) async {
    int imageCounter = 1;
    List<String> imagesURLs = [];
    for (int i = 0; i < images.length; i++) {
      final Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('compoundPics/$name/$name$imageCounter');
      imageCounter++;
      UploadTask task = firebaseStorageRef.putFile(images.elementAt(i));
      TaskSnapshot taskSnapshot = await task;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      imagesURLs.add(downloadURL);
    }
    return imagesURLs;
  }

  Future updateCompoundData({
    String name,
    String description,
    String meterPrice,
    String installementPlan,
    String deliveryDate,
    String governate,
    String district,
    String area,
    List<String> unitTypes,
    String availableUnitAreas,
    List<String> imagesURLs,
    double latitude,
    double longitude,
    String status,
    bool highlighted,
  }) async {
    return await compoundsCollection.doc().set({
      'name': name,
      'description': description,
      'meterPrice': meterPrice,
      'installementPlan': installementPlan,
      'deliveryDate': deliveryDate,
      'propertyTypes': unitTypes,
      'availablePropertyAreas': availableUnitAreas,
      'pictures': imagesURLs,
      'latitude': latitude,
      'longitude': longitude,
      'governate': governate,
      'district': district,
      'area': area,
      'status': status,
      'highlighted': highlighted,
    });
  }

  List<Compound> _compoundsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Compound(
        uid: doc.id,
        name: doc.data()['name'] ?? '',
        area: doc.data()['area'] ?? '',
        description: doc.data()['description'] ?? '',
        district: doc.data()['district'] ?? '',
        governate: doc.data()['governate'] ?? '',
        latitude: doc.data()['latitude'] ?? 0,
        propertyTypes: doc.data()['unitTypes'] ?? [],
        longitude: doc.data()['longitude'] ?? 0,
        images: doc.data()['pictures'] ?? [],
        meterPrice: doc.data()['meterPrice'] ?? 0,
        availablePropertyAreas: doc.data()['availablePropertyAreas'] ?? '',
        status: doc.data()['status'] ?? '',
        highlighted: doc.data()['highlighted'] ?? false,
        installementPlan: doc.data()['installementPlan'] ?? 0,
        deliveryDate: doc.data()['deliveryDate'] ?? '',
      );
    }).toList();
  }

  Future updatePropertyData({
    String title,
    String description,
    int numberBedrooms,
    int numberBathrooms,
    int price,
    int size,
    String governate,
    String district,
    String area,
    double latitude,
    double longitude,
    String type,
    List<String> imagesURLs,
    String userName,
    String userRole,
    String userNumber,
    String userId,
    String userPic,
    String userEmail,
    String userGender,
    int listingType,
    String status,
  }) async {
    return await propertiesCollection.doc().set({
      'title': title,
      'description': description,
      'numberBedrooms': numberBedrooms,
      'numberBathrooms': numberBathrooms,
      'price': price,
      'type': type,
      'pictures': imagesURLs,
      'latitude': latitude,
      'longitude': longitude,
      'governate': governate,
      'district': district,
      'area': area,
      'size': size,
      'listingType': listingType,
      'userName': userName,
      'userPic': userPic,
      'userId': userId,
      'userNumber': userNumber,
      'userRole': userRole,
      'userEmail': userEmail,
      'userGender': userGender,
      'status': status,
    });
  }

  List<Property> _propertiesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Property(
        uid: doc.id,
        title: doc.data()['title'] ?? '',
        area: doc.data()['area'] ?? '',
        description: doc.data()['description'] ?? '',
        district: doc.data()['district'] ?? '',
        governate: doc.data()['governate'] ?? '',
        latitude: doc.data()['latitude'] ?? 0,
        listingType: doc.data()['listingType'] ?? 0,
        longitude: doc.data()['longitude'] ?? 0,
        numBathrooms: doc.data()['numberBathrooms'] ?? 0,
        numBedrooms: doc.data()['numberBedrooms'] ?? 0,
        images: doc.data()['pictures'] ?? [],
        price: doc.data()['price'] ?? 0,
        size: doc.data()['size'] ?? 0,
        propertyType: doc.data()['type'] ?? '',
        agent: UserData(
          uid: doc.data()['userId'] ?? '',
          name: doc.data()['userName'] ?? '',
          phoneNumber: doc.data()['userNumber'] ?? '',
          picURL: doc.data()['userPic'] ?? '',
          role: doc.data()['userRole'] ?? '',
          email: doc.data()['userEmail'] ?? '',
          gender: doc.data()['userGender'] ?? '',
        ),
        status: doc.data()['status'] ?? '',
      );
    }).toList();
  }

  Stream<List<Compound>> getCompoundsBySearch({
    bool limited,
    String status,
    String governate,
    String district,
    String area,
    bool highlighted,
  }) {
    Query query = compoundsCollection;

    if (status != '') {
      query = query.where(
        'status',
        isEqualTo: status,
      );
    }

    if (highlighted != null) {
      query = query.where(
        'highlighted',
        isEqualTo: highlighted,
      );
    }

    if (governate != '') {
      query = query.where(
        'governate',
        isEqualTo: governate,
      );
    }
    if (district != '') {
      query = query.where(
        'district',
        isEqualTo: district,
      );
    }
    if (area != '') {
      query = query.where(
        'area',
        isEqualTo: area,
      );
    }

    return limited
        ? query.limit(10).snapshots().map(_compoundsListFromSnapshot)
        : query.snapshots().map(_compoundsListFromSnapshot);
  }

  Stream<List<Property>> getPropertiesBySearch({
    bool limited,
    String status,
    String propertyType,
    int listingType,
    String governate,
    String district,
    String area,
    int numberBedrooms,
    int numberBathrooms,
    int priceMin,
    int priceMax,
    int sizeMin,
    int sizeMax,
    String agentId,
  }) {
    Query query = propertiesCollection;
    if (propertyType != '') {
      query = query.where(
        'type',
        isEqualTo: propertyType,
      );
    }
    if (listingType != null) {
      query = query.where(
        'listingType',
        isEqualTo: listingType,
      );
    }
    if (governate != '') {
      query = query.where(
        'governate',
        isEqualTo: governate,
      );
    }
    if (district != '') {
      query = query.where(
        'district',
        isEqualTo: district,
      );
    }
    if (area != '') {
      query = query.where(
        'area',
        isEqualTo: area,
      );
    }

    if (numberBedrooms != null) {
      query = query.where(
        'numberBedrooms',
        isEqualTo: numberBedrooms,
      );
    }
    if (numberBathrooms != null) {
      query = query.where(
        'numberBathrooms',
        isEqualTo: numberBathrooms,
      );
    }
    if (status != '') {
      query = query.where(
        'status',
        isEqualTo: status,
      );
    }

    if (agentId != '') {
      query = query.where(
        'userId',
        isEqualTo: agentId,
      );
    }

    if (priceMin != null) {
      query = query.where(
        'price',
        isGreaterThanOrEqualTo: priceMin,
      );
    }
    if (priceMax != null) {
      query = query.where(
        'area',
        isLessThanOrEqualTo: priceMax,
      );
    }

    if (sizeMin != null) {
      query = query.where(
        'size',
        isGreaterThanOrEqualTo: sizeMin,
      );
    }
    if (sizeMax != null) {
      query = query.where(
        'size',
        isLessThanOrEqualTo: sizeMax,
      );
    }

    return limited
        ? query.limit(10).snapshots().map(_propertiesListFromSnapshot)
        : query.snapshots().map(_propertiesListFromSnapshot);
  }

  Future updateRequestData(
      {Property property, String date, UserData user}) async {
    return await requestsCollection.doc().set({
      'title': property.title,
      'description': property.description,
      'numberBedrooms': property.numBedrooms,
      'numberBathrooms': property.numBathrooms,
      'price': property.price,
      'type': property.propertyType,
      'pictures': property.images,
      'latitude': property.latitude,
      'longitude': property.longitude,
      'governate': property.governate,
      'district': property.district,
      'area': property.area,
      'size': property.size,
      'listingType': property.listingType,
      'agentName': property.agent.name,
      'agentPic': property.agent.picURL,
      'agentId': property.agent.uid,
      'agentNumber': property.agent.phoneNumber,
      'agentRole': property.agent.role,
      'agentEmail': property.agent.email,
      'agentGender': property.agent.gender,
      'userName': user.name,
      'userPic': user.picURL,
      'userId': user.uid,
      'userNumber': user.phoneNumber,
      'userEmail': user.email,
      'userGender': user.gender,
      'status': 'pending',
      'propertyId': property.uid,
      'propertyStatus': property.status,
      'date': date,
    });
  }

  List<Location> _areasListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Location(
        docId: doc.id,
        type: 2,
      );
    }).toList();
  }

  Stream<List<Location>> getAreas(String govName, districtName) {
    return FirebaseFirestore.instance
        .collection(
            "locations/" + govName + "/districts/" + districtName + '/areas')
        .snapshots()
        .map(_areasListFromSnapshot);
  }

  List<Location> _districtsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Location(
        docId: doc.id,
        type: 1,
      );
    }).toList();
  }

  Stream<List<Location>> getDistricts(String govName) {
    return FirebaseFirestore.instance
        .collection("locations/" + govName + "/districts")
        .snapshots()
        .map(_districtsListFromSnapshot);
  }

  List<Location> _governatesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Location(
        docId: doc.id,
        type: 0,
      );
    }).toList();
  }

  Stream<List<Location>> get governates {
    return locationsCollection.snapshots().map(_governatesListFromSnapshot);
  }

  List<Request> _appointmentRequestsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Request(
        property: Property(
          title: doc.data()['title'] ?? '',
          uid: doc.data()['propertyId'] ?? '',
          area: doc.data()['area'] ?? '',
          description: doc.data()['description'] ?? '',
          district: doc.data()['district'] ?? '',
          governate: doc.data()['governate'] ?? '',
          latitude: doc.data()['latitude'] ?? 0,
          listingType: doc.data()['listingType'] ?? 0,
          longitude: doc.data()['longitude'] ?? 0,
          numBathrooms: doc.data()['numberBathrooms'] ?? 0,
          numBedrooms: doc.data()['numberBedrooms'] ?? 0,
          images: doc.data()['pictures'] ?? [],
          price: doc.data()['price'] ?? 0,
          size: doc.data()['size'] ?? 0,
          propertyType: doc.data()['type'] ?? '',
          agent: UserData(
            uid: doc.data()['agentId'] ?? '',
            name: doc.data()['agentName'] ?? '',
            phoneNumber: doc.data()['agentNumber'] ?? '',
            picURL: doc.data()['agentPic'] ?? '',
            role: doc.data()['agentRole'] ?? '',
          ),
          status: doc.data()['propertyStatus'] ?? '',
        ),
        uid: doc.id,
        userId: doc.data()['userId'] ?? '',
        userName: doc.data()['userName'] ?? '',
        userNumber: doc.data()['userNumber'] ?? '',
        userPic: doc.data()['userPic'] ?? '',
        status: doc.data()['status'] ?? '',
        date: doc.data()['date'] ?? '',
      );
    }).toList();
  }

  Stream<List<Request>> getAppointmentRequestsBySearch(String status) {
    Query query = requestsCollection;
    if (status != '') {
      query = query.where(
        'status',
        isEqualTo: status,
      );
    }
    return query.snapshots().map(_appointmentRequestsListFromSnapshot);
  }

  Future updateAppointmentRequestStatus({
    String status,
    String requestId,
  }) async {
    try {
      await requestsCollection.doc(requestId).update({
        'status': status,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updatePropertyStatus({
    String status,
    String propertyID,
  }) async {
    try {
      await propertiesCollection.doc(propertyID).update({
        'status': status,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateCompoundStatus({
    String status,
    String compoundId,
  }) async {
    try {
      await compoundsCollection.doc(compoundId).update({
        'status': status,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<String> getUserRole() async {
    DocumentSnapshot s =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    // FirebaseMessaging _messaging = FirebaseMessaging();
    // String deviceToken = await _messaging.getToken();
    // String role = s.data()['role'];
    return s.data()['role'];
  }
}
