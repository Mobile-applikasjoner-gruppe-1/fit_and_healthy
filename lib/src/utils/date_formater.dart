import 'package:intl/intl.dart';

/**
   * The formatDate method, format the date as 'MMM d, yyyy'. 
   * This could be for example, 'November 13, 2024'
   */
String formatDate(DateTime date) {
  return DateFormat('MMMM d, yyyy').format(date);
}
