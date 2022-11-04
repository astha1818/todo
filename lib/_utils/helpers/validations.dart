import '../res/strings.dart';

class Validation {
  static String? titleValidation(String? text) {
    String title = text ?? '';
    if (title.trim().isEmpty) return AppString.pleaseEnterTitle;
    return null;
  }

  static String? descriptionValidation(String? text) {
    String title = text ?? '';
    if (title.trim().isEmpty) return AppString.pleaseEnterDescription;
    return null;
  }
}
