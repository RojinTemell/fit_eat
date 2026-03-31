extension FieldValidator on String? {
  // Validate Required Fields
  String? validateRequired(String fieldName) {
    if (this == null || this!.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }


}
