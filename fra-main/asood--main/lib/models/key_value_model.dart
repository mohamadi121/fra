import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'key_value_model.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class KeyValue extends Equatable {
  KeyValue({required this.key, required this.value}) : id = null; // تغییر از Isar.autoIncrement به null

  int id; // تغییر از Id به int
  final String key;
  final String value;

  @ignore
  @override
  List<Object> get props => [key, value];
}
