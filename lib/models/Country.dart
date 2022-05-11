class Country{
  final int id;
  final String countryName;
  final String iso;
  final String iso3;

  const Country({
  required this.id,
  required this.countryName,
  required this.iso,
  required this.iso3
  });

  factory Country.fromJson(Map<String, dynamic> json){
    return Country(
        id: json['id'],
        countryName: json['country_name'],
        iso: json['iso'],
        iso3: json['iso3'],
    );
  }

}