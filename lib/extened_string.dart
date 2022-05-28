extension extentedString on String {
  bool isDartFile() {
    return this.split('.').last == 'dart';
  }
}