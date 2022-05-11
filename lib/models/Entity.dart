class Entity{
  final int id;
  final int entityTypeId;
  final String? entityTypeName;
  final String name;
  final String email;
  final String? phoneNumber;
  final int addressId;
  final String taxNumber;
  final String defaultLanguage;

  const Entity({
    required this.id,
    required this.entityTypeId,
    this.entityTypeName,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.addressId,
    required this.taxNumber,
    required this.defaultLanguage,
  });

  factory Entity.fromJson(Map<String, dynamic> json){
    return Entity(
      id: json['id'],
      entityTypeId: json['entities_types_id'],
      name: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_numbers'],
      addressId:  json['adresses_id'],
      taxNumber: json['taxpayer_number'],
      defaultLanguage: json['default_language'],
    );
  }

  factory Entity.fromJsonDetailed(Map<String, dynamic> json){
    return Entity(
      id: json['id'],
      entityTypeId: json['entities_types_id']['id'],
      entityTypeName: json['entities_types_id']['name'],
      name: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_numbers'],
      addressId:  json['adresses_id'],
      taxNumber: json['taxpayer_number'],
      defaultLanguage: json['default_language'],
    );
  }

  @override
  String toString() {
    return "#" + id.toString() + " - " + name;
  }
}