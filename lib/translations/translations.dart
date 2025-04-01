import 'package:get/get.dart';
import 'en.dart';
import 'zh_Hans.dart';
import 'zh_Hant.dart';
import 'ja.dart';
import 'ko.dart';
import 'es.dart';
import 'fr.dart';
import 'de.dart';
import 'it.dart';
import 'pt.dart';
import 'nl.dart';
import 'ru.dart';
import 'pl.dart';
import 'tr.dart';
import 'sv.dart';
import 'nb.dart';
import 'da.dart';
import 'cs.dart';
import 'hu.dart';
import 'el.dart';
import 'ro.dart';
import 'hr.dart';
import 'sk.dart';
import 'sl.dart';
import 'bg.dart';
import 'sr.dart';
import 'uk.dart';
import 'hi.dart';
import 'ta.dart';
import 'te.dart';
import 'ms.dart';
import 'id.dart';
import 'vi.dart';
import 'th.dart';
import 'tl.dart';
import 'ar.dart';
import 'he.dart';
import 'fa.dart';
import 'am.dart';
import 'sw.dart';
import 'af.dart';
import 'la.dart';
import 'eo.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        // European Languages
        'en': en,
        'es': es,
        'fr': fr,
        'de': de,
        'it': it,
        'pt': pt,
        'nl': nl,
        'ru': ru,
        'pl': pl,
        'tr': tr,
        'sv': sv,
        'nb': nb,
        'da': da,
        'cs': cs,
        'hu': hu,
        'el': el,
        'ro': ro,
        'hr': hr,
        'sk': sk,
        'sl': sl,
        'bg': bg,
        'sr': sr,
        'uk': uk,

        // Asian Languages
        'zh_Hans': zh_Hans,
        'zh_Hant': zh_Hant,
        'ja': ja,
        'ko': ko,
        'hi': hi,
        'ta': ta,
        'te': te,
        'ms': ms,
        'id': id,
        'vi': vi,
        'th': th,
        'tl': tl,

        // Middle Eastern & African Languages
        'ar': ar,
        'he': he,
        'fa': fa,
        'am': am,
        'sw': sw,
        'af': af,

        // Other Languages
        'la': la,
        'eo': eo,
      };
}
