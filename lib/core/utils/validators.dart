class Validators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEventDate(DateTime? date) {
    if (date == null) {
      return 'Date is required';
    }
    if (date.isBefore(DateTime.now())) {
      return 'Event date must be in the future';
    }
    return null;
  }

  static String? validateMaxAttendees(String? value) {
    if (value == null || value.isEmpty) {
      return 'Maximum attendees is required';
    }
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter a valid number';
    }
    return null;
  }
}
