import 'package:url_launcher/url_launcher.dart';

void openLink(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'No se pudo abrir el enlace $url';
  }
}
