class Compound {
  final String uid;
  final String area;
  final String district;
  final String governate;
  final String name;
  final String description;
  final List propertyTypes;
  final String availablePropertyAreas;
  final List images;
  final int installementPlan;
  final int meterPrice;
  final double latitude;
  final double longitude;
  final String status;
  final String deliveryDate;
  final bool highlighted;

  Compound({
    this.highlighted,
    this.name,
    this.propertyTypes,
    this.availablePropertyAreas,
    this.installementPlan,
    this.meterPrice,
    this.deliveryDate,
    this.status,
    this.uid,
    this.area,
    this.district,
    this.governate,
    this.description,
    this.images,
    this.latitude,
    this.longitude,
  });
}
