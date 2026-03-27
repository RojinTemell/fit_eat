extension FieldValidator on String? {
  // Validate Required Fields
  String? validateRequired(String fieldName) {
    if (this == null || this!.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // // Validate Numbers (for Servings/Minutes)
  // String? validateNumber(String fieldName) {
  //   if (this == null || this!.trim().isEmpty) return null; // Optional
  //   if (double.tryParse(this!) == null) {
  //     return 'Please enter a valid number for $fieldName';
  //   }
  //   return null;
  // }
}
