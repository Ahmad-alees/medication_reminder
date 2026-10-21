import 'package:flutter/material.dart';

IconData getFormIcon(String form) {
  switch (form.toLowerCase()) {
    case 'capsule':
    case 'كبسولة':
      return Icons.medication_liquid_rounded;
    case 'syrup':
    case 'شراب':
      return Icons.local_drink_rounded;
    case 'injection':
    case 'حقنة':
      return Icons.vaccines_rounded;
    case 'drops':
    case 'قطرة':
      return Icons.water_drop_rounded;
    default:
      return Icons.medication_rounded;
  }
}
