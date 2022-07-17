class Meta{
  final int current_page;
  final int from;
  final int last_page;
  final String path;
  final int per_page;
  final int to;
  final int total;

  const Meta({
    required this.current_page,
    required this.from,
    required this.last_page,
    required this.path,
    required this.per_page,
    required this.to,
    required this.total
  });

  factory Meta.fromJson(Map<String, dynamic> json){
    return Meta(
        current_page: json['current_page'],
        from: json['from'] ?? 0,
        last_page: json['last_page'],
        path: json['path'],
        per_page: json['per_page'],
        to: json['to'] ?? 0,
        total: json['total']
    );
  }
}