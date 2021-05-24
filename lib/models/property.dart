import 'package:realestate/models/user.dart';

class Property {
  final String uid;
  final String area;
  final String district;
  final String governate;
  final String propertyType;
  final int listingType;
  final List images;
  final List amenities;
  final int price;
  final int size;
  final int numBathrooms;
  final int numBedrooms;
  final double latitude;
  final double longitude;
  final UserData agent;
  final String status;

  Property({
    this.amenities,
    this.agent,
    this.status,
    this.uid,
    this.area,
    this.district,
    this.governate,
    this.propertyType,
    this.listingType,
    this.images,
    this.price,
    this.size,
    this.numBathrooms,
    this.numBedrooms,
    this.latitude,
    this.longitude,
  });
}
