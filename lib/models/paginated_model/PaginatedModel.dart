import 'Meta.dart';

class PaginatedModel<T>{
  final List<T> data;
  final Meta meta;

  const PaginatedModel({
    required this.data,
    required this.meta,
  });

}