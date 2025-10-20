/// Asset paths for the application
class AppAssets {
  AppAssets._();

  // Base paths
  static const String _iconsPath = 'assets/icons';

  // Equipment Icons
  static const String barbell = '$_iconsPath/barbell.png';
  static const String dumbbell = '$_iconsPath/dumbbell.png';
  static const String cable = '$_iconsPath/cable.png';
  static const String bodyweight = '$_iconsPath/bodyweight.png';

  /// Get equipment icon path by equipment type
  static String getEquipmentIcon(String equipment) {
    switch (equipment.toLowerCase()) {
      case 'barbell':
        return barbell;
      case 'dumbbell':
        return dumbbell;
      case 'cable':
        return cable;
      case 'bodyweight':
        return bodyweight;
      default:
        return dumbbell; // Default fallback
    }
  }

  /// Get equipment display name
  static String getEquipmentDisplayName(String equipment) {
    switch (equipment.toLowerCase()) {
      case 'barbell':
        return 'Barbell';
      case 'dumbbell':
        return 'Dumbbell';
      case 'cable':
        return 'Cable';
      case 'bodyweight':
        return 'Bodyweight';
      default:
        return equipment;
    }
  }
}

