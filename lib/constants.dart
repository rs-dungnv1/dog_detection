import 'dart:ui';

class Constants {
  Constants._();

  static const Color grey1 = Color(0xFFF1F4F6);
  static const Color grey2 = Color(0xFF9FA0A0);

  static const String pageTitle = 'Dog Breed Identification';
  static const String resultText =
      'The dog you just scanned is one of the following breeds';
  static const String introLabel = "Find a Dog but don't know the breed?";
  static const String introContent =
      "Scan & identify dog breeds anytime anywhere";
  static const String noDogLabel =
      'Unable to identify any dogs in the photo above';
  static const String noDogContent = 'please take a picture which have a dog';

  static const String gallery = 'From gallery';
  static const String takePhotoText = 'Take Photo';
  static const String accuracyText = '% Match';
}
