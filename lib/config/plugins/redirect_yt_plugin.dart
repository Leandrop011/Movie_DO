import 'package:url_launcher/url_launcher.dart';

class RedirectYtPlugin {
  // ? TIENE QUE SER UN EVENTO FUTURO PORQUE LO INVOCAREMOS CUANDO LO NECESITEMOS EN UN FUTURO
  static Future<void> openYoutube(String url) async{
    // ? parsea el url
    final Uri uri = Uri.parse(url);

    // ? CONDICION DE QUE SI PUEDE ABRIR ESE URL
    if( await canLaunchUrl(uri) ){
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, //* abre YT
      );
    }
  }
}