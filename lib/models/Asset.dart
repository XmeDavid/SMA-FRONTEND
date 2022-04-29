class Asset{
  final int id;
  final int entitiesId;
  final int? userId;
  final int? ticketId;
  final String brand;
  final String model;
  final String serialNumber;
  final int assetStatusId;
  final String purchaseDate;
  final int warrantyMonths;
  final double purchasePrice;
  final int assetTypeId;

  const Asset({
    required this.id,
    required this.entitiesId,
    required this.userId,
    required this.ticketId,
    required this.brand,
    required this.model,
    required this.serialNumber,
    required this.assetStatusId,
    required this.purchaseDate,
    required this.warrantyMonths,
    required this.purchasePrice,
    required this.assetTypeId,
  });

  factory Asset.fromJson(Map<String, dynamic> json){
    return Asset(
      id: json['id'],
      entitiesId: json['entities_id'],
      userId: json['users_id'],
      ticketId: json['tickets_id'],
      brand: json['brand'],
      model: json['model'],
      serialNumber: json['serial_number'],
      assetStatusId: json['assets_status_id'],
      purchaseDate: json['purchase_date'],
      warrantyMonths : json['warranty_months'],
      purchasePrice: json['purchase_price'],
      assetTypeId: json['assets_types_id'],
    );
  }

  @override
  String toString() {
    return "Asset #" + id.toString() + " - " + brand + " " + model + " - #" + serialNumber;
  }
}