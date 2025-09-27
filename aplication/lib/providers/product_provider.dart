import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

enum Status { idle, loading, success, error }

class ProductProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  List<Product> _all = [];
  List<Product> _filtered = [];
  Status _status = Status.idle;
  String _errorMessage = '';

  // pagination client-side
  int _pageSize = 10;
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  List<Product> get products => _filtered;
  Status get status => _status;
  String get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isFetchingMore => _isFetchingMore;

  Future<void> loadInitial({bool force = false}) async {
    if (_status == Status.loading && !force) return;
    _status = Status.loading;
    notifyListeners();
    try {
      _all = await _api.fetchProducts();
      _currentPage = 0;
      _hasMore = _all.length > _pageSize;
      _applyPagination();
      _status = Status.success;
    } catch (e) {
      _status = Status.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void _applyPagination() {
    final end = (_currentPage + 1) * _pageSize;
    final safeEnd = end.clamp(0, _all.length);
    _filtered = _all.sublist(0, safeEnd);
    _hasMore = _filtered.length < _all.length;
  }

  Future<void> fetchMore() async {
    if (!_hasMore || _isFetchingMore) return;
    _isFetchingMore = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300)); // small delay
    _currentPage++;
    _applyPagination();

    _isFetchingMore = false;
    notifyListeners();
  }

  void search(String query) {
    if (query.trim().isEmpty) {
      // reset to current paginated list
      _applyPagination();
    } else {
      final q = query.toLowerCase();
      _filtered = _all.where((p) =>
        p.title.toLowerCase().contains(q) ||
        p.description.toLowerCase().contains(q) ||
        p.category.toLowerCase().contains(q)
      ).toList();
    }
    notifyListeners();
  }

  Future<void> addProduct(Product p) async {
    _status = Status.loading;
    notifyListeners();
    try {
      final created = await _api.createProduct(p);
      _all.insert(0, created);
      _applyPagination();
      _status = Status.success;
    } catch (e) {
      _status = Status.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> updateProduct(Product p) async {
    if (p.id == null) {
      _errorMessage = 'Product ID is null';
      _status = Status.error;
      notifyListeners();
      return;
    }
    _status = Status.loading;
    notifyListeners();
    try {
      final updated = await _api.updateProduct(p.id!, p);
      final idx = _all.indexWhere((x) => x.id == p.id);
      if (idx != -1) _all[idx] = updated;
      _applyPagination();
      _status = Status.success;
    } catch (e) {
      _status = Status.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    _status = Status.loading;
    notifyListeners();
    try {
      final ok = await _api.deleteProduct(id);
      if (ok) {
        _all.removeWhere((p) => p.id == id);
        _applyPagination();
      } else {
        throw Exception('Delete failed');
      }
      _status = Status.success;
    } catch (e) {
      _status = Status.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Product? getById(int id) {
    return _all.firstWhere((p) => p.id == id, orElse: () => Product(
      id: null,
      title: '',
      price: 0,
      description: '',
      category: '',
      image: '',
    ));
  }
}
