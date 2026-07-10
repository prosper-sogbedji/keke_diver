import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// Valide un numéro complet (indicatif + numéro national) via
/// la base de données réelle des formats téléphoniques par pays.
bool isValidPhone(String dialCode, String nationalNumber) {
  if (nationalNumber.isEmpty) return false;
  try {
    final phone = PhoneNumber.parse('$dialCode$nationalNumber');
    return phone.isValid();
  } catch (_) {
    return false;
  }
}
