import 'package:share_plus/share_plus.dart';

// ? METODO QUE ACCEDEREMOS AL METODO DE SHARE PLUS PARA
// ? GENERAR UN ENLACE 
class SharePlugin {
  
  static void shareLink(String link, String subject){
    SharePlus.instance.share(
      ShareParams(
        text: link,
        subject: subject,
      )
    );
  }

}
