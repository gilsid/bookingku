/// Interface repository untuk data lapangan.
import 'package:bookingku/features/field/domain/entities/field.dart';
import 'package:bookingku/shared/models/result.dart';

abstract class FieldRepository {
  Future<Result<List<Field>>> getFields();
  Future<Result<Field>> getFieldDetail(int id);
}
