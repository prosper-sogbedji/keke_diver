
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constantes.dart';

log(dynamic x)
{
  if(kDebugMode)
  {
    print(x);
  }
}




String decimail_format(int a)
{
  switch(a)
  {
    case 0:
      return "00";
    case 1:
      return "01";
    case 2:
      return "02";
    case 3:
      return "03";
    case 4:
      return "04";
    case 5:
      return "05";
    case 6:
      return "06";
    case 7:
      return "07";
    case 8:
      return "08";
    case 9:
      return "09";
    default:
      return a.toString();
  }
}
String date_time_now()
{
  DateTime now=DateTime.now();
  return "${decimail_format(now.day)}/${decimail_format(now.month)}/${now.year} - ${decimail_format(now.hour)} : ${decimail_format(now.minute)}";
}



String truncateText(String text, {int maxLength = 12}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return text.substring(0, maxLength) + "...";
  }
}


Future<void> openWebsite({required String lien}) async {
  final Uri url = Uri.parse(lien);
  //  final Uri url = Uri.parse('https://www.google.com');
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Impossible d’ouvrir $url');
  }
}

Future<void> launchPhone({required String tel }) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: tel);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    // Affichez un message d'erreur ou un SnackBar si l'appel ne peut pas être lancé
    print('Impossible de lancer l\'appel.');
  }
}

Future<void> callNumber({required phoneNumber}) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );

  if (!await launchUrl(launchUri)) {
    throw Exception('Impossible de lancer l\'appel vers $phoneNumber');
  }
}


Future<void> launchEmail({required mail}) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: mail,
    queryParameters: {
      'subject': 'Demande l\'information',
      'body': '',
    },
  );
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    print('Impossible de lancer l\'e-mail.');
  }
}


Future<void> sendMail({required String email}) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    query: Uri.encodeFull('subject=Demande d\'informations&body=Salut, '),
  );

  if (!await launchUrl(emailUri)) {
    throw Exception('Impossible d\'ouvrir le client mail');
  }
}

String return_lang()
{return interne_storage.read(lang)??"en";}


/*
bool estDateExpiree(String dateString) {
  try {

    // Exemple attendu : "30/09/28 - 13h19"

    // Séparer date et heure
    final parts = dateString.split(' - ');

    if (parts.length != 2) return false;

    // Partie date
    final dateParts = parts[0].split('/');
    if (dateParts.length != 3) return false;

    // Partie heure
    final heureParts = parts[1].replaceAll('h', ':').split(':');
    if (heureParts.length != 2) return false;

    final jour = int.parse(dateParts[0]);
    final mois = int.parse(dateParts[1]);

    // Ici 28 => 2028
    final annee = 2000 + int.parse(dateParts[2]);

    final heure = int.parse(heureParts[0]);
    final minute = int.parse(heureParts[1]);

    final date = DateTime(
      annee,
      mois,
      jour,
      heure,
      minute,
    );

    // true = date passée
    return date.isBefore(DateTime.now());

  } catch (e) {
    return false;
  }
}
*/



bool dateEstExpiree(String timestamp) {
  try {

    // convertir le timestamp en int
    final int seconds = int.parse(timestamp);

    // convertir en DateTime
    final date = DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000,
    );

    // true = date passée
    return date.isBefore(DateTime.now());

  } catch (e) {
    return false;
  }
}