/// Longueur exacte du numéro national (sans l'indicatif) par indicatif pays.
/// Sert UNIQUEMENT à limiter la saisie clavier en temps réel.
/// La validation finale se fait via phone_numbers_parser (plus fiable).
const Map<String, int> phoneLengthByDialCode = {
  '+229': 10, // Bénin
  '+228': 8, // Togo
  '+225': 10, // Côte d'Ivoire
  '+221': 9, // Sénégal
  '+223': 8, // Mali
  '+226': 8, // Burkina Faso
  '+227': 8, // Niger
  '+33': 9, // France (sans le 0 initial)
  '+1': 10, // USA/Canada
};

const int defaultPhoneLength = 9;

int expectedLengthFor(String dialCode) {
  return phoneLengthByDialCode[dialCode] ?? defaultPhoneLength;
}
