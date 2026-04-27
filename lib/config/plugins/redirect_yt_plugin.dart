import 'package:url_launcher/url_launcher.dart';

// ! PLUGIN QUE TIENE COMO OBJETIVO REDIRECCIONAR HACIA YT SI SUCEDE UN ERROR
class RedirectYtPlugin {
  static Future<void> openYoutube(String url) async{
    final Uri uri = Uri.parse(url);
    if( await canLaunchUrl(uri) ){
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}