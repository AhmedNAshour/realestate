class Compound {
  final String logoURL;
  final String uid;
  final String locationLevel2;
  final String locationLevel1;
  final String name;
  final String description;
  final List propertyTypes;
  final List facilities;
  final String areasAndUnits;
  final List images;
  final String paymentPlan;
  final int meterPrice;
  final int startingPrice;
  final double latitude;
  final double longitude;
  final String status;
  final String deliveryDate;
  final String finishingType;
  final bool highlighted;

  Compound({
    this.facilities,
    this.logoURL,
    this.startingPrice,
    this.finishingType,
    this.highlighted,
    this.name,
    this.propertyTypes,
    this.areasAndUnits,
    this.paymentPlan,
    this.meterPrice,
    this.deliveryDate,
    this.status,
    this.uid,
    this.locationLevel2,
    this.locationLevel1,
    this.description,
    this.images,
    this.latitude,
    this.longitude,
  });
}
