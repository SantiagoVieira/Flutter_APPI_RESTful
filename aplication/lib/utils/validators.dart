class Validators {
  static String? required(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo requerido';
    return null;
  }

  static String? optionalUrl(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final pattern = RegExp(r'^(https?:\/\/).+');
    if (!pattern.hasMatch(v.trim())) return 'Ingrese una URL válida (http/https)';
    return null;
  }
}
