import 'package:share_plus/share_plus.dart';

// ? METODO QUE GENERAR UN ENLACE PARA EL PROCESO DE DEEPLINKING 
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
