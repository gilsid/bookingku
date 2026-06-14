/// FieldProvider untuk manajemen state data lapangan.
import 'package:flutter/material.dart';
import 'package:bookingku/features/field/domain/entities/field.dart';
import 'package:bookingku/features/field/domain/repositories/field_repository.dart';

class FieldProvider extends ChangeNotifier {
  final FieldRepository _fieldRepository;

  List<Field> _fields = [];
  Field? _selectedField;
  bool _isLoading = false;
  String? _errorMessage;

  FieldProvider(this._fieldRepository);

  List<Field> get fields => _fields;
  Field? get selectedField => _selectedField;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Memuat daftar lapangan.
  Future<void> fetchFields() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _fieldRepository.getFields();

    result.when(
      success: (data) {
        _fields = data;
        _isLoading = false;
        notifyListeners();
      },
      failure: (msg) {
        _errorMessage = msg;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Memuat detail lapangan berdasarkan ID.
  Future<void> fetchFieldDetail(int id) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedField = null;
    notifyListeners();

    final result = await _fieldRepository.getFieldDetail(id);

    result.when(
      success: (data) {
        _selectedField = data;
        _isLoading = false;
        notifyListeners();
      },
      failure: (msg) {
        _errorMessage = msg;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
